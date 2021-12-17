class AtreaDuplex
  include Singleton

  cattr_reader :controls

  def initialize
    super
    @@controls ||= {}
  end

  # @param [Home] home
  def control(home)
    unless @@controls[home.id]
      Rails.logger.debug "init new duplex for #{home.id}"
      @@controls[home.id] = AtreaControl::Duplex.new login: home.atrea_login, password: home.atrea_password
    end
    refresh_tokens!(home)
    @@controls[home.id]
  end

  # @param [Home] home
  def data(home)
    c = control(home)
    c.call_unit!
  rescue RestClient::Forbidden
    Rails.logger.debug "session expired..."
    home.update duplex_login_in_progress: true, duplex_valid_for: Time.zone.now
    begin
      c.login && c.close
    rescue Selenium::WebDriver::Error
      begin
        @@controls[home.id]&.close
      rescue Errno::ECONNREFUSED, Selenium::WebDriver::Error::UnknownError
        # Try close current browser
      end
      @@controls.delete(home.id)
      (c = control(home)).login && c.close
    end
    home.update({
                  duplex_name: c.name,
                  duplex_user_id: c.user_id,
                  duplex_unit_id: c.unit_id,
                  duplex_auth_token: c.auth_token,
                  duplex_valid_for: Time.zone.now,
                  duplex_login_in_progress: false,
                  duplex_user_texts: c.user_texts,
                  duplex_user_modes: c.user_modes,
                  duplex_modes: c.modes,
                })

    c.call_unit!
  end

  private

  # setup new tokens for RD5 communication by Home object
  # @param [Home] home
  def refresh_tokens!(home)
    @@controls[home.id].user_id = home.duplex_user_id
    @@controls[home.id].unit_id = home.duplex_unit_id
    @@controls[home.id].auth_token = home.duplex_auth_token
    @@controls[home.id].user_texts = home.duplex_user_texts
    @@controls[home.id].user_modes = home.duplex_user_modes
    @@controls[home.id].modes = home.duplex_modes
    @@controls[home.id]
  end

end
