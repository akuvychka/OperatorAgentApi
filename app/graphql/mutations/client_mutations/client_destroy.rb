module Mutations::ClientMutations
  class ClientDestroy < Mutations::BaseMutation
    argument :id, Integer, required: true

    type Types::ClientType

    def resolve(id: nil)
      return permission_error unless context[:ability].can? :destroy, Client

      client = Client.find(id)

      client.destroy
      client
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new(e.record.errors.full_messages.join(','))
    rescue ActiveRecord::RecordNotFound => e
      entity_error
    end
  end
end