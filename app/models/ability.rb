# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new
    
    alias_action :create, :read, :update, :destroy, to: :crud

    if user.is_admin?
      can :manage, :all
    end
    
    can(:crud, Idea) do |idea|
      idea.user == user 
    end

    can(:crud, Review) do |review|
      review.user == user
    end

    can :like, Idea do |idea|
      user.persisted? && idea.user != user
    end

    can :destroy, Like do |like|
      like.user = user
    end

  end
end
