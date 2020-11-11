module Mutations::ContractMutations
  class ContractDestroy < Mutations::BaseMutation
    argument :id, Integer, required: true

    type Types::ContractType

    def resolve(id: nil)
      return permission_error unless context[:ability].can? :destroy, Contract

      contract = Contract.find(id)

      contract.destroy
      contract
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new(e.record.errors.full_messages.join(','))
    rescue ActiveRecord::RecordNotFound => e
      entity_error
    end
  end
end