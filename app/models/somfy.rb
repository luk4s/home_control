class Somfy

  attr_reader :home

  # @param [Home] home
  def initialize(home)
    @home = home
  end

  def client
    @client ||= OAuth2::Client.new(home.somfy_client_id, home.somfy_secret, {
      site: "https://accounts.somfy.com",
      authorize_url: 'oauth/oauth/v2/auth',
      token_url: 'oauth/oauth/v2/token',
      raise_errors: false
    })
  end

  def authorize(context)
    client.auth_code.authorize_url(redirect_uri: callback_url(context), state: SecureRandom.hex(8), grant_type: "authorization_code")
  end

  def get_code(code, context)
    client.auth_code.get_token(code, redirect_uri: callback_url(context))
  end

  def connection
    @connection ||= OAuth2::AccessToken.new(client, home.somfy_token, { refresh_token: home.somfy_refresh_token })
  end

  def refresh!
    @connection = connection.refresh!
    home.update(somfy_token: @connection.token, somfy_refresh_token: @connection.refresh_token)
    @connection
  end

  def request(type, path, params = {})
    @last_request = [type, path, params]
    response = connection.request(type, path, params)
    parse_response(response)
  end

  private

  def callback_url(context)
    # Rails.application.routes.url_helpers.somfy_home_url
    context.somfy_home_url
    "https://fotky.svatebni.info/home/somfy"
  end
end
