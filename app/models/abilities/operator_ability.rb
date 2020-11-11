# frozen_string_literal: true

class Abilities::OperatorAbility
  include CanCan::Ability

  def initialize
    can :manage, :all
    cannot :compare, Insurance
  end
end
