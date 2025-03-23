FactoryBot.define do
  factory :user, aliases: [:author] do
    sequence(:email) { |n| "#{n}-#{Faker::Internet.email}" }
    admin { false }
    password { SecureRandom.hex(16) }
    confirmed_at { Time.zone.now }

    trait :admin do
      admin { true }
    end
  end
end

