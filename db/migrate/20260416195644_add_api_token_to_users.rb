class AddApiTokenToUsers < ActiveRecord::Migration[8.0]

  def change
    add_column :users, :api_token, :string
    add_index :users, :api_token, unique: true

    # Backfill existing users with secure tokens
    reversible do |dir|
      dir.up do
        User.find_each do |user|
          user.update_column(:api_token, SecureRandom.base58(24))
        end

        # Now make it non-nullable
        change_column_null :users, :api_token, false
      end
    end
  end

end
