require "atrea_duplex"

class Home < ApplicationRecord
  include PgCryptoable

  attr_pgcrypto :atrea_password, :somfy_client_id, :somfy_secret
  belongs_to :user, class_name: "Symphonia::User"

  store_accessor :duplex_auth_options, :user_id, :unit_id, :auth_token, :login_in_progress, :valid_for, prefix: :duplex
  store_accessor :duplex_user_ctrl, :name, :user_texts, :modes, :user_modes, :sensors

  store_accessor :influxdb_options, :url, :token, :org, :bucket, prefix: :influxdb

  # @return [AtreaDuplex] with duplex sensor output
  def duplex
    @duplex ||= AtreaDuplex.new(self)
  end

  def somfy
    @somfy ||= Somfy.new self
  end

  def scenario=(name)
    case name
    when "poweroff"
      duplex.power_off!
    when "auto"
      duplex.automatic!
    when "ventilate"
      duplex.control.mode = 1
      duplex.control.power = 80
    else
      # no supported yet
    end
  end

  # @return [String] "measurement" of all data bucket
  def influxdb_id
    "home-#{id}"
  end

end
