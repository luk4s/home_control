RSpec.describe "homes/new", type: :view do
  login_user
  let!(:home) { build :my_home }

  before do
    assign :home, home
    render
  end

  it { expect(rendered).to include("h1", t(:heading_new_home)) }
end