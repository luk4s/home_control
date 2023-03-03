FactoryBot.define do
  factory :my_home, class: "Home" do
    user
    atrea_login { Faker::Internet.unique.email || "default@email.cz" }
    atrea_password { Faker::Internet.password || SecureRandom.hex(4) }
    influxdb_options do
      { "org" => "", "url" => "", "token" => "", "bucket" => "" }
    end
  end
end
