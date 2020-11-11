module Mutations::InsuranceMutations
  class InsuranceDestroy < Mutations::BaseMutation
    argument :id, Integer, required: true

    type Types::InsuranceType

    def resolve(id: nil)
      return permission_error unless context[:ability].can? :destroy, Insurance

      insurance = Insurance.find(id)

      insurance.destroy
      insurance
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new(e.record.errors.full_messages.join(','))
    rescue ActiveRecord::RecordNotFound => e
      entity_error
    end
  end
end