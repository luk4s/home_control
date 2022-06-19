class AtreaDuplex

  attr_reader :home

  def initialize(home)
    @home = home
  end

  def control
    login_and_update_tokens! unless home.duplex_auth_token
    @control ||= AtreaControl::Duplex::Unit.new user_id: home.duplex_user_id, unit_id: home.duplex_unit_id, sid: home.duplex_auth_token, user_ctrl: home
  end

  def login_and_update_tokens!
    Rails.logger.debug "New login in progress..."
    home.update(duplex_login_in_progress: true, duplex_valid_for: Time.zone.now)
    duplex_tokens = AtreaControl::Duplex::Login.user_tokens login: home.atrea_login, password: home.atrea_password
    Rails.logger.debug "Login success => #{duplex_tokens}..."
    user_ctrl = AtreaControl::Duplex::UserCtrl.data(**duplex_tokens)
    home.update!({
                   duplex_valid_for: Time.zone.now,
                   duplex_login_in_progress: false,
                   duplex_user_id: duplex_tokens[:user_id],
                   duplex_unit_id: duplex_tokens[:unit_id],
                   duplex_auth_token: duplex_tokens[:sid],
                   duplex_user_ctrl: user_ctrl,
                 })
  end

  def data
    control.values
  rescue RestClient::Forbidden
    Rails.logger.debug "session expired..."
    remove_instance_variable :@control
    login_and_update_tokens! && control.values
  end

  def automatic!
    control.power = 0
    control.mode = 1
  end

  def power_off!
    control.power = 0
    control.mode = 0
  end

  def as_json(*_args)
    data.merge(sid: home.duplex_auth_token, login_in_progress: home.duplex_login_in_progress, valid_for: home.duplex_valid_for)
  end

end
