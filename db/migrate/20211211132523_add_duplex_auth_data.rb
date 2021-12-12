class AddDuplexAuthData < ActiveRecord::Migration[6.1]

  def change
    add_column :homes, :duplex_auth_options, :jsonb
  end

end
