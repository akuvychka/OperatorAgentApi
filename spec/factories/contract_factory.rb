FactoryBot.define do
  factory :contract do
    sequence(:user) { create(:insurance_agent) }
    client
    sequence(:insurance) { create(:insurance_life) }
  end
end