class ApiTokensController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.regenerate_api_token
    redirect_to edit_user_registration_path, notice: t(:api_token_regenerated)
  end

end
