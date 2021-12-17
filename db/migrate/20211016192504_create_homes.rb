class CreateHomes < ActiveRecord::Migration[6.1]

  def change
    enable_extension 'pgcrypto'

    create_table :homes do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :atrea_login
      t.binary :atrea_password
      t.binary :somfy_client_id
      t.binary :somfy_secret
      t.string :somfy_token
      t.string :somfy_refresh_token

      t.timestamps
    end
  end

end
