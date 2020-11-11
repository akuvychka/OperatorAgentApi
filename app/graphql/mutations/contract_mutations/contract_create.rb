module Mutations::ContractMutations
  class ContractCreate < Mutations::BaseMutation
    argument :client_id, Integer, required: true
    argument :insurance_id, Integer, required: true
    argument :user_id, Integer, required: false

    type Types::ContractType

    def resolve(client_id: nil, insurance_id: nil, user_id:nil)
      return permission_error unless context[:ability].can? :create, Contract

      Contract.create!(
        client_id: client_id,
        user_id: user_id || context[:current_user].id,
        insurance_id: insurance_id
      )

    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new(e.record.errors.full_messages.join(','))
    end
  end
end