module ControllerMacros
  def login_admin
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      admin = FactoryBot.create(:user, :admin)
      sign_in :user, admin # sign_in(scope, resource)
    end
  end

  def login_user
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryBot.create(:user)
      sign_in user
    end
  end
end