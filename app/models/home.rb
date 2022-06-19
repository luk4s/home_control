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

  # @param [String] mode
  # @param [Integer] power
  def manual_control!(mode:, power:)
    available_modes = duplex.control.user_ctrl.modes
    mode_id = available_modes.key(mode)
    raise ArgumentError, "mode #{mode} is not allowed. Possible modes: #{available_modes.values.join(', ')}" unless mode_id

    duplex.control.mode = mode_id.to_i
    duplex.control.power = power.to_i
  end

  def scenario=(name)
    case name
    when "poweroff"
      duplex.power_off!
    when "auto"
      duplex.automatic!
    when "ventilate"
      duplex.control.mode = 2
      duplex.control.power = 90
    else
      # no supported yet
    end

    name
  end

  # @return [String] "measurement" of all data bucket
  def influxdb_id
    # "home-#{id}"
    "atrea"
  end

end
