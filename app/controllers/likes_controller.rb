class LikesController < ApplicationController
    before_action :authenticate_user!

    def create
        idea = Idea.find params[:idea_id]
        like = Like.new(user: current_user, idea: idea)
        if can? :like, idea
            if like.save
                flash[:success] = "Idea liked"
            else
                flash[:danger] = like.errors.full_messages.join(", ")
            end
            redirect_to idea
        else
            flash[:danger] = "You can't like your own idea!" 
            redirect_to idea_path(idea)
        end
    end

    def destroy
        like = current_user.likes.find params[:id]
        if can? :destroy, like
            like.destroy
            flash[:success] = "Idea unliked"
            redirect_to idea_path(like.idea)
        else
            flash[:alert] = "Can't delete like!"
        end
    end
end
