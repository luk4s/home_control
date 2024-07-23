RSpec.describe "homes/show", :logged do
  helper_method :current_user

  before do
    allow(view).to receive(:current_user).and_return(Symphonia::User.current)
  end

  context "with home" do
    let(:home) { create :my_home, user: Symphonia::User.current }

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
