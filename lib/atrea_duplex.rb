class AtreaDuplex
  include Singleton

  cattr_reader :controls

  def initialize
    super
    @@controls ||= {}
  end

  # @param [Home] user
  def control(user)
    unless @@controls[user.id]
      Rails.logger.debug "init new duplex for #{user.id}"
      @@controls[user.id] = AtreaControl::Duplex.new login: user.atrea_login, password: user.atrea_password

    end
    unless @@controls[user.id].logged? && !@@controls[user.id].login_in_progress?
      @@controls[user.id].login
      Rails.logger.debug "duplex logged"
    end
    # @@controls[user.id].login unless @@controls[user.id].logged?
    @@controls[user.id]
  rescue Errno::ECONNREFUSED, Selenium::WebDriver::Error::WebDriverError
    @@controls[user.id].close
    @@controls.delete(user.id)
    control(user)
  end

end
