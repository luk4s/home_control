FactoryBot.define do
  factory :my_home, class: "Home" do
    user
    atrea_login { Faker::Internet.unique.email }
    atrea_password { Faker::Internet.password }
    somfy_client_id { Faker::Internet.password }
    somfy_secret { Faker::Internet.device_token }
    somfy_refresh_token { Faker::Internet.device_token }
  end
end
