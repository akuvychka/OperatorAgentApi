FactoryBot.define do
  factory :insurance_life, class: Insurance do
    sequence(:agency_name) { 'Agency' }
    sequence(:insurance_type) { 'life' }
    sequence(:total_cost) { 199.99 }
    sequence(:period) { 'monthly' }
  end

  factory :insurance_property, class: Insurance do
    sequence(:agency_name) { 'Agency' }
    sequence(:insurance_type) { 'property' }
    sequence(:total_cost) { 1099.99 }
    sequence(:period) { 'monthly' }
  end
end