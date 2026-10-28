RSpec.describe HomesController, type: :controller do
  describe "#show" do
    subject { get :show }

    context "without login" do
      it { is_expected.to redirect_to(/sign_in/) }
    end

    context "without home" do
      login_user
      it { is_expected.to redirect_to "/home/new" }
    end

    context "with home" do
      login_user
      before { FactoryBot.create :my_home, user: controller.current_user }

      it { is_expected.to have_http_status :ok }

      it "json format" do
        allow_any_instance_of(AtreaDuplex).to receive(:data).and_return({ some: "data" })
        get :show, format: :json
        expect(response).to have_http_status :ok
      end
    end

    context "with an expired Atrea session" do
      login_user

      let(:tokens) { { user_id: "new-user", unit_id: "new-unit", sid: "new-token" } }
      let(:old_unit) { instance_double(AtreaControl::Duplex::Unit) }
      let(:fresh_unit) { instance_double(AtreaControl::Duplex::Unit) }

      before do
        FactoryBot.create(:my_home, user: controller.current_user, duplex_auth_token: "old-token", duplex_user_ctrl: { input_temperature_source: "rd5_standard" })
        allow(AtreaControl::Duplex::Unit).to receive(:new).and_return(old_unit, fresh_unit)
        allow(old_unit).to receive(:values).and_raise(AtreaControl::SessionExpired)
        allow(AtreaControl::Duplex::Login).to receive(:user_tokens).and_return(tokens)
        allow(AtreaControl::Duplex::UserCtrl).to receive(:data).and_return({ input_temperature_source: "rd5_standard" })
      end

      it "logs in again and returns readings with the renewed session" do
        allow(fresh_unit).to receive(:values).and_return({ current_power: 88.0 })
        expect(AtreaControl::Duplex::Login).to receive(:user_tokens).once

        get :show, format: :json

        expect([response.status, response.parsed_body]).to match([200, a_hash_including("current_power" => 88.0, "sid" => "new-token")])
      end

      it "returns reconnecting state when the renewed session is not ready yet" do
        allow(fresh_unit).to receive(:values).and_raise(AtreaControl::SessionExpired)
        expect { get :show, format: :json }.to have_enqueued_job(DuplexReadDataJob)

        expect([response.status, response.parsed_body, response.headers["Retry-After"]]).to eq([202, { "login_in_progress" => true }, "5"])
      end
    end
  end

  describe "#update" do
    login_user
    let!(:home) { FactoryBot.create :my_home, user: controller.current_user }

    it "permitted params" do
      expect { put :update, params: { id: home, home: { influxdb_url: "https://some.flux" } } }.to change(home, :influxdb_options)
    end
  end

  describe "#reset" do
    subject(:reset) { get :reset, params: { id: home } }

    login_user
    let(:home) { FactoryBot.create :my_home, status: "login_in_progress", user: controller.current_user, duplex_auth_options: { user_id: 1, unit_id: "0123", auth_token: "abc20" } }

    before do
      allow(DuplexReadDataJob).to receive(:perform_now)
    end

    it { is_expected.to redirect_to(/home/) }

    it "remove auth token" do
      expect { reset }.to change { home.reload.duplex_auth_token }.to nil
    end

    it "reset status" do
      expect { reset }.to change { home.reload.status }.to "pending"
    end
  end

  describe "Bearer token authentication" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:home) { FactoryBot.create(:my_home, user:) }

    context "with valid bearer token" do
      before do
        allow_any_instance_of(AtreaDuplex).to receive(:data).and_return({ some: "data" })
        request.headers["Authorization"] = "Bearer #{user.api_token}"
      end

      it "authenticates user and returns json" do
        get :show, format: :json
        expect(response).to have_http_status :ok
        expect(response.content_type).to match(%r{application/json})
      end
    end

    context "with invalid bearer token" do
      before do
        request.headers["Authorization"] = "Bearer invalid_token_xyz"
      end

      it "returns unauthorized" do
        get :show, format: :json
        expect(response).to have_http_status :unauthorized
      end
    end

    context "without bearer token" do
      it "returns unauthorized" do
        get :show, format: :json
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
