class DuplexReadDataJob < ApplicationJob
  queue_as :default

  unique :until_and_while_executing, on_conflict: :log, runtime_lock_ttl: 3.minutes

  retry_on AtreaControl::Error, wait: 5.seconds, attempts: 3 do |job, exception|
    job.logger.error "Error reading data from RD5: #{exception.message}"
    job.arguments.first.status_failed!
  end

  # @param [Home] home
  def perform(home)
    return unless (data = home.duplex.data)

    DuplexChannel.broadcast_to(home.user, data)

    # return if (influxdb = Rails.application.credentials[:influxdb]).blank?
    return unless (influxdb = home.influxdb_options)
    return if home.influxdb_url.blank?

    influxdb.symbolize_keys!
    client = InfluxDB2::Client.new(influxdb[:url], influxdb[:token], {
      precision: InfluxDB2::WritePrecision::SECOND,
    }.reverse_merge(influxdb))
    write_api = client.create_write_api
    write_api.write(data: "#{home.influxdb_id},current_mode=#{data[:current_mode]} power=#{data[:current_power]},outdoor_temperature=#{data[:outdoor_temperature]},input_temperature=#{data[:input_temperature]}")

    # client.create_delete_api.delete(Time.zone.now.ago(1.hour), Time.zone.now)
  end

end
