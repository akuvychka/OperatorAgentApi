# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user = nil)
    return unless user.present?

    self.merge(Abilities::AgentAbility.new) if user.is? :agent
    self.merge(Abilities::OperatorAbility.new) if user.is? :operator
  end
end
