require "atrea_duplex"

class Home < ApplicationRecord
  include PgCryptoable

  define_singleton_method(:decrypted_atrea_password) do
    ActiveRecord::PGCrypto::SymmetricCoder.decrypted_arel_text(arel_table[:atrea_password])
  end
  serialize :atrea_password, coder: ActiveRecord::PGCrypto::SymmetricCoder

  belongs_to :user

  store_accessor :duplex_auth_options, :user_id, :unit_id, :auth_token, prefix: :duplex
  store_accessor :duplex_user_ctrl, :name, :user_texts, :modes, :user_modes, :sensors

  store_accessor :influxdb_options, :url, :token, :org, :bucket, prefix: :influxdb

  validates :atrea_login, presence: true

  enum :status, {
    pending: "pending",
    login_in_progress: "login_in_progress",
    authenticated: "authenticated",
    failed: "failed",
  }, prefix: true, default: :pending

  scope :active, -> { where.not(status: "login_in_progress").where.not(atrea_password: nil) }

  # @return [AtreaDuplex] with duplex sensor output
  def duplex
    @duplex ||= AtreaDuplex.new(self)
  end

  # @param [String] mode
  # @param [Integer] power
  def manual_control!(mode:, power:)
    available_modes = duplex.control.user_ctrl.modes
    mode_id = available_modes.key(mode)
    raise ArgumentError, "mode #{mode} is not allowed. Possible modes: #{available_modes.values.join(', ')}" unless mode_id

    duplex.control.power = power.to_i
    duplex.control.mode = mode_id.to_i
  end

  # https://control.atrea.eu/comm/sw/unit.php?ver=003001022&_user=2113&_unit=126399332270040&_t=config/xml.cgi&auth=10317&H1070800100=&_w=1
  # https://control.atrea.eu/comm/sw/unit.php?ver=003001009&_user=2113&_unit=126399332270040&_t=config/xml.cgi&auth=16398&H1070800077&H1070000002&_w=1
  # # H1070800083 => 83%
  # # H1070800100 => 100%
  #   H1070800090
  # H1070900001 +  H1070100002 => auto
  # H1070900002 => vetrani
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
  end

  # @return [String] "measurement" of all data bucket
  def influxdb_id
    # "home-#{id}"
    "atrea"
  end

end
