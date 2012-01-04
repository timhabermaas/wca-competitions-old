class AdminAbility
  include CanCan::Ability

  def initialize(user)
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

    if user && user.admin?
      can :manage, :all
    elsif user && user.organizer?
      can [:edit, :update], News, :user_id => user.id
      can :manage, News, :competition => { :user_id => user.id }
      can [:new, :create], Competition
      can [:edit, :update, :show], Competition, :user_id => user.id
      can [:edit, :update], Registration, :competition => { :user_id => user.id }
      can :manage, Schedule, :competition => { :user_id => user.id }
    end
  end
end
