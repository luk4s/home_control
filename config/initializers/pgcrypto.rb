require "active_record/pgcrypto"
# Replace the default environment variable name with your own value/key.
ActiveRecord::PGCrypto::SymmetricCoder.pgcrypto_key = Rails.application.credentials[:pgcrypt_key]
