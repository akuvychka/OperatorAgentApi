module Types
  class ClientType < Types::BaseObject
    field :id, Integer, null: false
    field :email, String, null: false
    field :name, String, null: true
    field :surname, String, null: true
  end
end