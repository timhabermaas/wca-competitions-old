class Ability
  include CanCan::Ability

  def initialize(user)
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

    can :read, Competition
    can :read, Schedule
    can [:index, :compare, :stats], Registration
    can [:new, :create], Registration, :competition => { :closed => false }
  end
end
