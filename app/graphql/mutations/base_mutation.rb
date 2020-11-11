module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject
    null false

    def permission_error
      GraphQL::ExecutionError.new('Permission denied')
    end

    def entity_error
      GraphQL::ExecutionError.new('There is no requested entity')
    end
  end
end
