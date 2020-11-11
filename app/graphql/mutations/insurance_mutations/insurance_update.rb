module Mutations::InsuranceMutations
  class InsuranceUpdate < Mutations::BaseMutation
    argument :id, Integer, required: true
    argument :name, String, required: false
    argument :agency_name, String, required: false
    argument :insurance_type, String, required: false
    argument :total_cost, Float, required: false
    argument :period, String, required: false

    type Types::InsuranceType

    def resolve(id: nil, name: nil, agency_name: nil, insurance_type: nil, total_cost: nil, period: nil)
      return permission_error unless context[:ability].can? :update, Insurance

      insurance = Insurance.find(id)

      insurance.update!(
        agency_name: agency_name || insurance.agency_name,
        name: name || insurance.name,
        insurance_type: insurance_type || insurance.insurance_type,
        total_cost: total_cost || insurance.total_cost,
        period: period || insurance.period
      )
      insurance
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new(e.record.errors.full_messages.join(','))
    rescue ActiveRecord::RecordNotFound => e
      entity_error
    end
  end
end