module Mutations::UserMutations
  class UserUpdate < Mutations::BaseMutation
    argument :id, Integer, required: true
    argument :email, String, required: false
    argument :user_role, String, required: false
    argument :name, String, required: false
    argument :surname, String, required: false
    argument :contacts, [Integer], required: false

    type Types::UserType

    def resolve(id: nil, email: nil, user_role: nil, name: nil, surname: nil, contacts: [])
      user = User.find(id)

      return permission_error unless (context[:ability].can? :update, User) || (Abilities::ManageUserAbility.new(context[:current_user], user).can? :update, User)

      user.update!(
        email: email || user.email,
        user_role: user_role || user.user_role,
        name: name || user.name,
        surname: surname || user.surname
      )

      user.contacts.destroy_all

      contacts.each do |contact|
        Companion.find_or_create_by(user_id: id, contact_id: contact).save
      end
      user.reload
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new(e.record.errors.full_messages.join(','))
    rescue ActiveRecord::RecordNotFound => e
      entity_error
    end
  end
end