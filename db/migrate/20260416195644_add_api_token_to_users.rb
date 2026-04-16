class AddApiTokenToUsers < ActiveRecord::Migration[8.0]

  def change
    # Add column as nullable first
    add_column :users, :api_token, :string

    # Backfill existing users with secure random tokens using PostgreSQL
    reversible do |dir|
      dir.up do
        # Use gen_random_uuid() to generate unique tokens for existing users
        # This requires pgcrypto extension (already enabled in this app)
        execute <<-SQL
          UPDATE users#{' '}
          SET api_token = encode(gen_random_bytes(18), 'base64')
          WHERE api_token IS NULL;
        SQL
      end
    end

    # Add unique index
    add_index :users, :api_token, unique: true

    # Make column non-nullable after backfill
    reversible do |dir|
      dir.up do
        change_column_null :users, :api_token, false
      end
    end
  end

end
