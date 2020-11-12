FactoryBot.define do
  factory :operator, class: User do
    sequence(:email) { "test_operator@email.email" }
    sequence(:user_role) { "operator" }
  end

  factory :agent, class: User do
    sequence(:email) { "test_agent@email.email" }
    sequence(:user_role) { "agent" }
  end

  factory :insurance_agent, class: User do
    sequence(:email) { "test_insurance_agent@email.email" }
    sequence(:user_role) { "agent" }
  end
end