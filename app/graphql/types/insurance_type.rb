module Types
  class InsuranceType < Types::BaseObject
    field :id, Integer, null: false
    field :name, String, null: true
    field :agency_name, String, null: false
    field :insurance_type, String, null: false
    field :total_cost, Float, null: false
    field :period, String, null: false
  end
end