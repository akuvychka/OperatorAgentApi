# frozen_string_literal: true

class Abilities::ManageUserAbility
  include CanCan::Ability

  def initialize(user, target)
    if user.id == target.id
      can :update, User
    elsif target.user_role == 'operator' && user.contacts.include?(target)
      can %i[read update], User
    end
  end
end
