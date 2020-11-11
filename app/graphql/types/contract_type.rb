module Types
  class ContractType < Types::BaseObject
    field :id, Integer, null: false
    field :user, UserType, null: false
    field :client, ClientType, null: false
    field :insurance, InsuranceType, null: false
  end
end