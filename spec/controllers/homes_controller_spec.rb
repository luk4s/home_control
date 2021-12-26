RSpec.describe HomesController, type: :controller do
  describe "#show" do
    subject { get :show }

    context "without login" do
      it { is_expected.to redirect_to "/login" }
    end

    context "without home", logged: true do
      it { is_expected.to redirect_to "/home/new" }
    end

    context "with home", logged: true do
      let!(:home) { FactoryBot.create :my_home, user: controller.current_user }

      it { is_expected.to have_http_status :ok }
    end
  end

  describe "#update", logged: true do
    let!(:home) { FactoryBot.create :my_home, user: controller.current_user }

    it "permitted params" do
      expect { put :update, params: { id: home, home: { influxdb_url: "https://some.flux" } } }.to change(home, :influxdb_options)
    end
  end

end
