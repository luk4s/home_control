class AtreaDuplex
  include Singleton

  cattr_reader :controls

  def initialize
    super
    @@controls ||= {}
  end

  def control(user)
    unless @@controls[user.id]
      @@controls[user.id] = AtreaControl::Duplex.new login: user.atrea_login, password: user.atrea_password
      @@controls[user.id].login
      Rails.logger.debug "login new duplex"
    end
    @@controls[user.id].login unless @@controls[user.id].logged?
    @@controls[user.id]
  end

end
