# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    alias_action :voteup, :votedown, :revote, to: :vote
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Subscription]
    can [:update, :destroy], [Question, Answer, Comment, Subscription], user: user
    can :create_comment, [Question, Answer]
    can :best, Answer do |answer|
      answer.user != user && answer.question.user == user
    end

    can :vote, [Question, Answer] do |resource|
      resource.user != user
    end
  end
end
