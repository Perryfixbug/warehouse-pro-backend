# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    else
      can :manage, Product
      can :read, User, id: user.id
      can :update, User, id: user.id
    end
  end
end
