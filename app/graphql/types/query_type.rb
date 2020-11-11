module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :user_list, [Types::UserType], null: true, description: 'Returns all users'
    field :operators, [Types::UserType], null: true, description: 'Returns all operators sorted by contact count'
    field :user, Types::UserType, null: true do
      description 'Find a user by ID'
      argument :id, Integer, required: true
    end
    field :compare, Types::InsuranceType, null: true do
      description 'Compare price of insurance depends on monthly price and returns the chipiest'
      argument :list, [Integer], required: true
    end
    field :client_list, [Types::ClientType], null: true, description: 'Returns all clients'
    field :contract_list, [Types::ContractType], null: true, description: 'Returns all contracts'

    def user_list
      return permission_error unless context[:ability].can? :list, User

      User.all
    end

    def client_list
      return permission_error unless context[:ability].can? :list, Client

      Client.all
    end

    def contract_list
      return permission_error unless context[:ability].can? :list, Contract

      Contract.all
    end

    def user(params)
      user =  User.find(params[:id])
      return permission_error unless (context[:ability].can? :read, User) || (Abilities::ManageUserAbility.new(context[:current_user], user).can? :read, User)

      user
    rescue ActiveRecord::RecordNotFound => e
      entity_error
    end

    def operators
      return permission_error unless context[:ability].can? :operators, User

      User.where(user_role: 'operator').left_joins(:companions).group(:id).order('COUNT(companions.contact_id) DESC')
    end

    def permission_error
      GraphQL::ExecutionError.new('Permission denied')
    end

    def entity_error
      GraphQL::ExecutionError.new('There is no requested entity')
    end

    def compare(params)
      return permission_error unless context[:ability].can? :compare, Insurance

      minimal_price = Float::MAX
      lower_price_insurance = nil

      params[:list].each do |id|
        insurance = Insurance.find(id)
        price = if insurance.period == 'monthly'
                  insurance.total_cost
                else
                  insurance.total_cost / 12
                end
        if price < minimal_price
          minimal_price = price
          lower_price_insurance = insurance
        end
      end

      lower_price_insurance
    rescue ActiveRecord::RecordNotFound => e
      entity_error
    end
  end
end
