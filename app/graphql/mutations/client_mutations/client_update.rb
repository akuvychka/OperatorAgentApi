module Mutations::ClientMutations
  class ClientUpdate < Mutations::BaseMutation
    argument :id, Integer, required: true
    argument :email, String, required: false
    argument :name, String, required: false
    argument :surname, String, required: false

    type Types::ClientType

    def resolve(id: nil, email: nil, name: nil, surname: nil)
      return permission_error unless context[:ability].can? :update, Client

      client = Client.find(id)

      client.update!(
        email: email || client.email,
        name: name || client.name,
        surname: surname || client.surname
      )
      client
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new(e.record.errors.full_messages.join(','))
    rescue ActiveRecord::RecordNotFound => e
      entity_error
    end
  end
end