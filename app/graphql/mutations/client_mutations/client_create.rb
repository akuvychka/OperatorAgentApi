module Mutations::ClientMutations
  class ClientCreate < Mutations::BaseMutation
    argument :email, String, required: true
    argument :name, String, required: false
    argument :surname, String, required: false

    type Types::ClientType

    def resolve(**args)
      return permission_error unless context[:ability].can? :create, Client

      Client.create!(args)

    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new(e.record.errors.full_messages.join(','))
    end
  end
end