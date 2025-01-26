RSpec.describe HomesController, type: :controller do
  describe "#show" do
    subject { get :show }

    context "without login" do
      it { is_expected.to redirect_to "/login" }
    end

    context "without home", :logged do
      it { is_expected.to redirect_to "/home/new" }
    end

    context "with home", :logged do
      before { FactoryBot.create :my_home, user: controller.current_user }

      it { is_expected.to have_http_status :ok }
    end
  end

  describe "#update", :logged do
    let!(:home) { FactoryBot.create :my_home, user: controller.current_user }

    it "permitted params" do
      expect { put :update, params: { id: home, home: { influxdb_url: "https://some.flux" } } }.to change(home, :influxdb_options)
    end
  end

  describe "#reset", :logged do
    subject(:reset) { get :reset, params: { id: home } }

    let(:home) { FactoryBot.create :my_home, user: controller.current_user, duplex_auth_options: { user_id: 1, unit_id: "0123", auth_token: "abc20" } }

    before do
      allow(DuplexReadDataJob).to receive(:perform_now)
    end

    it { is_expected.to redirect_to(/home/) }

    it "remove auth token" do
      expect { reset }.to change { home.reload.duplex_auth_token }.to nil
    end
  end
end
