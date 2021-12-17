class ReadDuplexJob < ApplicationJob
  queue_as :default

  discard_on StandardError do |_job, error|
    logger.error error
  end

  # @param [Home] home
  def perform(home)
    # If another process current logging into RD5, die
    return if home.duplex_login_in_progress
    return unless (data = home.duplex)

    DuplexChannel.broadcast_to(home.user, data)
    return unless (influxdb = home.influxdb_options)

    client = InfluxDB2::Client.new(influxdb.delete("url"), influxdb.delete("token"), {
      precision: InfluxDB2::WritePrecision::SECOND,
    }.reverse_merge(influxdb.symbolize_keys))
    write_api = client.create_write_api
    # influx_data = {
    #   name: "power",
    #   fields: {
    #     power: data[:current_power],
    #     outdoor_temperature: data[:outdoor_temperature],
    #   },
    #   tags: { mode: data[:current_mode] },
    # }
    # write_api.write data: InfluxDB2::Point.from_hash(influx_data)
    write_api.write(data: "air,current_mode=#{data[:current_mode]} power=#{data[:current_power]}")
    write_api.write(data: "outdoor_temperature,sensor=atrea temperature=#{data[:outdoor_temperature]}")


    # client.create_delete_api.delete(Time.zone.now.ago(1.hour), Time.zone.now)
  end

end
