module Mutations::InsuranceMutations
  class InsuranceCreate < Mutations::BaseMutation
    argument :name, String, required: false
    argument :agency_name, String, required: true
    argument :insurance_type, String, required: true
    argument :total_cost, Float, required: true
    argument :period, String, required: true

    type Types::InsuranceType

    def resolve(**args)
      return permission_error unless context[:ability].can? :create, Insurance

      Insurance.create!(args)

    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new(e.record.errors.full_messages.join(','))
    end
  end
end