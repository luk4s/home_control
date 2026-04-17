RSpec.describe ApiTokensController, type: :controller do
  describe "#create" do
    subject(:regenerate) { post :create }

    context "without login" do
      it { is_expected.to redirect_to(/sign_in/) }
    end

    context "with authenticated user" do
      login_user
      let(:user) { controller.current_user }
      let(:old_token) { user.api_token }

      it "regenerates the token" do
        old_token # force evaluation
        expect { regenerate }.to change { user.reload.api_token }.from(old_token)
      end

      it "redirects to profile with notice" do
        regenerate
        expect(response).to redirect_to(edit_user_registration_path)
        expect(flash[:notice]).to be_present
      end
    end
  end
end
