module Types
  class MutationType < Types::BaseObject
    field :create_user, mutation: Mutations::UserMutations::UserCreate
    field :update_user, mutation: Mutations::UserMutations::UserUpdate
    field :destroy_user, mutation: Mutations::UserMutations::UserDestroy

    field :create_client, mutation: Mutations::ClientMutations::ClientCreate
    field :update_client, mutation: Mutations::ClientMutations::ClientUpdate
    field :destroy_client, mutation: Mutations::ClientMutations::ClientDestroy

    field :create_insurance, mutation: Mutations::InsuranceMutations::InsuranceCreate
    field :update_insurance, mutation: Mutations::InsuranceMutations::InsuranceUpdate
    field :destroy_insurance, mutation: Mutations::InsuranceMutations::InsuranceDestroy

    field :create_contract, mutation: Mutations::ContractMutations::ContractCreate
    field :update_contract, mutation: Mutations::ContractMutations::ContractUpdate
    field :destroy_contract, mutation: Mutations::ContractMutations::ContractDestroy
  end
end
