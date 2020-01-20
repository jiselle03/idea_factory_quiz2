class IdeasController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :find_idea, only: [:edit,:update,:show, :destroy]

    def new
        @idea = Idea.new
    end

    def create
        @idea = Idea.new idea_params
        @idea.user = current_user
        if @idea.save
            flash[:notice] = 'Idea created successfully'
            redirect_to idea_path(@idea.id)
        else
            render :new
        end
    end

    def edit
        
    end

    def update
        if @idea.update idea_params
            flash[:notice] = 'Idea updated successfully'
            redirect_to idea_path(@idea.id)
        else
            render :edit
        end
    end

    def index
        @ideas = Idea.all.order(created_at: :desc)
    end

    def show
        @review = Review.new
        @reviews = @idea.reviews.order(created_at: :desc)
        @like = @idea.likes.find_by(user: current_user)
    end

    def destroy
        @idea.destroy
        redirect_to root_path
    end

    private

    def idea_params
        params.require(:idea).permit(:title, :description)
    end

    def find_idea
        @idea = Idea.find params[:id]
    end
end
