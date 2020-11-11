module Mutations::UserMutations
  class UserDestroy < Mutations::BaseMutation
    argument :id, Integer, required: true

    type Types::UserType

    def resolve(id: nil)
      return permission_error unless context[:ability].can? :destroy, User

      user = User.find(id)

      user.destroy
      user
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new(e.record.errors.full_messages.join(','))
    rescue ActiveRecord::RecordNotFound => e
      entity_error
    end
  end
end