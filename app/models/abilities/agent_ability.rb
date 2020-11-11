# frozen_string_literal: true

class Abilities::AgentAbility
  include CanCan::Ability

  def initialize
    can %i[create update list], Client
    can %i[create update list], Contract
    can :compare, Insurance
  end
end
