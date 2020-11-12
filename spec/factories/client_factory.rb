FactoryBot.define do
  factory :client do
    sequence(:email) { "client@email.email" }
    sequence(:name) { "new_client" }
  end
end