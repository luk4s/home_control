class AddInfluxdbData < ActiveRecord::Migration[6.1]

  def change
    add_column :homes, :influxdb_options, :jsonb
  end

end
