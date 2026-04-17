class ApplicationController < ActionController::Base
  # include Symphonia::ControllerExtensions
  # helper Symphonia::ApplicationHelper

  before_action :authenticate_with_bearer_token_if_json

  private

  def authenticate_with_bearer_token_if_json
    return unless request.format.json?
    return if current_user.present? # already authenticated via session

    authenticate_with_http_token do |token, _options|
      user = User.find_by(api_token: token)
      sign_in(user, store: false) if user
    end
  end

end
