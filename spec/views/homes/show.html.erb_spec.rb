RSpec.describe "homes/show" do
  login_user

  context "with home" do
    let(:home) { create :my_home, user: view.current_user }

    before do
      assign(:home, home)
      allow(home).to receive(:duplex).and_return spy
    end

    it "renders without error" do
      render
      expect(rendered).to include t :legend_atrea
    end
  end
end
