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
end
