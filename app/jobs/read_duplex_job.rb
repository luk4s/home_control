class ReadDuplexJob < ApplicationJob
  queue_as :default

  discard_on StandardError do |_job, error|
    logger.error error
  end

  # @param [Home] home
  def perform(home)
    # If another process current logging into RD5, die
    return if home.duplex_login_in_progress
    return unless (data = home.duplex.data)

    DuplexChannel.broadcast_to(home.user, data)

    # return if (influxdb = Rails.application.credentials[:influxdb]).blank?
    return unless (influxdb = home.influxdb_options)
    return if home.influxdb_url.blank?

    client = InfluxDB2::Client.new(influxdb[:url], influxdb[:token], {
      precision: InfluxDB2::WritePrecision::SECOND,
    }.reverse_merge(influxdb))
    write_api = client.create_write_api
    write_api.write(data: "#{home.influxdb_id},current_mode=#{data[:current_mode]} power=#{data[:current_power]},outdoor_temperature=#{data[:outdoor_temperature]},input_temperature=#{data[:input_temperature]}")

    # client.create_delete_api.delete(Time.zone.now.ago(1.hour), Time.zone.now)
  end

end
