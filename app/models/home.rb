require "atrea_duplex"

class Home < ApplicationRecord
  include PgCryptoable

  attr_pgcrypto :atrea_password, :somfy_client_id, :somfy_secret
  belongs_to :user, class_name: "Symphonia::User"

  def duplex
    @duplex ||= AtreaDuplex.instance.control(self)
  end

end
