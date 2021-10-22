# @see https://github.com/stas/active_record-pgcrypto
module PgCryptoable

  extend ActiveSupport::Concern

  class_methods do
    def attr_pgcrypto(*attributes)
      attributes.each do |attribute|
        define_singleton_method("decrypted_#{attribute}".to_sym) do
          ActiveRecord::PGCrypto::SymmetricCoder
            .decrypted_arel_text(arel_table[attribute])
        end

        serialize attribute, ActiveRecord::PGCrypto::SymmetricCoder
      end
    end
  end
end
