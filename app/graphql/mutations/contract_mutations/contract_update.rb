module Mutations::ContractMutations
  class ContractUpdate < Mutations::BaseMutation
    argument :id, Integer, required: true
    argument :user_id, Integer, required: false
    argument :client_id, Integer, required: false
    argument :insurance_id, Integer, required: false

    type Types::ContractType

    def resolve(id: nil, user_id: nil, client_id: nil, insurance_id: nil)
      return permission_error unless context[:ability].can? :update, Contract

      contract = Contract.find(id)

      contract.update!(
        user_id: user_id || contract.user_id,
        client_id: client_id || contract.client_id,
        insurance_id: insurance_id || contract.insurance_id
      )
      contract
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new(e.record.errors.full_messages.join(','))
    rescue ActiveRecord::RecordNotFound => e
      entity_error
    end
  end
end