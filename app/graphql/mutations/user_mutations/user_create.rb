module Mutations::UserMutations
  class UserCreate < Mutations::BaseMutation
    argument :email, String, required: true
    argument :user_role, String, required: true
    argument :name, String, required: false
    argument :surname, String, required: false
    argument :contacts, [Integer], required: false

    type Types::UserType

    def resolve(email: nil, user_role: nil, name: nil, surname: nil, contacts: [])
      return permission_error unless context[:ability].can? :create, User

      user = User.create!(email: email, name: name, surname: surname, user_role: user_role)

      contacts.each do |contact|
        Companion.find_or_create_by(user_id: user.id, contact_id: contact).save
      end
      user.reload
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new(e.record.errors.full_messages.join(','))
    end
  end
end