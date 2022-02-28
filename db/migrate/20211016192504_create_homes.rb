class CreateHomes < ActiveRecord::Migration[6.1]

  def change
    enable_extension 'pgcrypto'

    create_table :homes do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :atrea_login
      t.binary :atrea_password

      t.timestamps
    end
  end

end
