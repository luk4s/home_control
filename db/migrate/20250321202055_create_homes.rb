class CreateHomes < ActiveRecord::Migration[6.1]

  def change
    enable_extension "pgcrypto"

    create_table :homes do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :atrea_login
      t.binary :atrea_password
      t.string :status, default: "pending", null: false, index: true
      t.jsonb :duplex_user_ctrl
      t.jsonb :duplex_auth_options
      t.jsonb :influxdb_options

      t.timestamps
    end
  end

end
