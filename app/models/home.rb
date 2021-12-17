require "atrea_duplex"

class Home < ApplicationRecord
  include PgCryptoable

  attr_pgcrypto :atrea_password, :somfy_client_id, :somfy_secret
  belongs_to :user, class_name: "Symphonia::User"

  store_accessor :duplex_auth_options, :user_id, :unit_id, :auth_token, :name, :login_in_progress, :valid_for, :user_texts, :modes, :user_modes, prefix: :duplex

  store_accessor :influxdb_options, :url, :token, :org, :bucket, prefix: :influxdb

  # @return [Hash] with duplex sensor output
  def duplex
    AtreaDuplex.instance.data(self)
  end

  def somfy
    @somfy ||= Somfy.new self
  end

end
