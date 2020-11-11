module Types
  class UserType < Types::BaseObject
    field :id, Integer, null: false
    field :email, String, null: false
    field :name, String, null: true
    field :surname, String, null: true
    field :user_role, String, null: false
    field :contacts, [UserType], null: true
  end
end