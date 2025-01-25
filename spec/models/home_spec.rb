RSpec.describe Home do
  subject(:home) { create :my_home }

  describe ".active" do
    subject(:scope_active) { described_class.active }

    it { is_expected.to eq [] }

    context "with active home" do
      let!(:active_home) { create :my_home, status: "pending", atrea_password: Faker::Internet.password, atrea_login: Faker::Superhero.name }

      it { is_expected.to eq [active_home] }
    end

    context "with login_in_progress home" do
      before { create :my_home, status: "login_in_progress" }

      it { is_expected.to eq [] }
    end
  end
end
