require 'rails_helper'

RSpec.describe IdeasController, type: :controller do

    def current_user
        @current_user ||= FactoryBot.create(:user)
    end

    describe '#new' do
        context 'with user signed in' do
            before do
                session[:user_id] = current_user.id
            end

            it 'should render the new template' do
                get(:new)
                expect(response).to render_template(:new)
            end

            it 'should set an instance variable with a new idea' do
                get(:new)
                expect(assigns :idea).to be_a_new(Idea)
            end
        end

        context 'with no user signed in' do
            it 'should redirect to session#new' do
                get(:new)
                expect(response).to redirect_to(new_session_path)
            end

            it 'should send a flash danger message' do
                get(:new)
                expect(flash[:danger]).to be
            end
        end
    end

    describe '#create' do
        def valid_request
            post(:create, params: { idea: FactoryBot.attributes_for(:idea) })
        end
        def invalid_request
            post(:create, params: { idea: FactoryBot.attributes_for(:idea, title: nil) })
        end
        
        context 'with user signed in' do
            before do
                session[:user_id] = current_user.id
            end

            context 'with valid parameters' do

                it 'should create a new idea in the db' do
                    count_before = Idea.count
                    valid_request
                    count_after = Idea.count
                    expect(count_after).to eq(count_before + 1)
                end

                it 'should redirect to the show page of that idea' do
                    valid_request
                    idea = Idea.last
                    expect(response).to redirect_to(idea_path idea)
                end
            end

            context 'with invalid parameters' do

                it 'should assign an invalid idea as an instance variable' do
                    invalid_request
                    expect(assigns :idea).to be_a(Idea)
                    expect(assigns(:idea).valid?).to be(false)
                end
                
                it 'should render the new template' do
                    invalid_request
                    expect(response).to render_template(:new)
                end
                
                it 'should not create an idea in the db' do
                    count_before = Idea.count
                    invalid_request
                    count_after = Idea.count
                    expect(count_after).to eq(count_before)
                end
            end
        end

        context 'with no user signed in' do

            it 'should redirect to session#new' do
                valid_request
                expect(response).to redirect_to(new_session_path)
            end

            it 'should send a flash danger message' do
                valid_request
                expect(flash[:danger]).to be
            end

        end
    end
            
    describe '#show' do
        it 'should render the show template' do
            idea = FactoryBot.create(:idea)
            get(:show, params: { id: idea.id })
            expect(response).to render_template(:show)
        end

        it 'should set an instance variable idea for the shown object' do
            idea = FactoryBot.create(:idea)
            get(:show, params: { id: idea.id })
            expect(assigns :idea).to eq(idea)
        end
    end
    
    describe '#destroy' do
        context 'with user signed in' do
            before do
                session[:user_id] = current_user.id
            end

            context 'as owner' do
                before do
                    @idea = FactoryBot.create(:idea, user: current_user)
                    delete(:destroy, params: { id: @idea.id })
                end

                it 'should remove an idea from the db' do
                    expect(Idea.find_by id: @idea.id).to be(nil)
                end

                it 'redirects to the ideas index' do
                    expect(response).to redirect_to root_path
                end
            end

            context 'as non-owner' do
                before do
                    @idea = FactoryBot.create(:idea)
                    delete(:destroy, params: { id: @idea.id })
                end
    
                it 'redirects to idea show' do
                    expect(response).to redirect_to idea_path(@idea)
                end
    
                it 'sets a flash danger' do
                    expect(flash[:danger]).to be
                end
    
                it 'does not remove an idea' do
                    expect(Idea.find_by(id: @idea.id)).to eq(@idea)
                end
                
            end
        end

        context 'with no user signed in' do
            before do
                idea = FactoryBot.create(:idea)
                current_user = nil
                delete(:destroy, params: { id: idea.id })
            end

            it 'should redirect to session#new' do
                expect(response).to redirect_to(new_session_path)
            end

            it 'should send a flash danger message' do 
                expect(flash[:danger]).to be
            end
        end

    end

    describe '#index' do
        it 'should render the index template' do
            get(:index)
            expect(response).to render_template(:index)
        end
        it 'should render a list of ideas' do
            idea1 = FactoryBot.create(:idea)
            idea2 = FactoryBot.create(:idea)
            get(:index)
            expect(assigns :ideas).to match_array([idea1, idea2])
        end
    end

    describe '#edit' do
        context 'with user signed in' do
            before do
                session[:user_id] = current_user.id
            end

            context 'as owner' do
                before do
                    @idea = FactoryBot.create(:idea, user: current_user)
                    get(:edit, params: { id: @idea.id })
                end

                it 'should render the edit template' do
                    expect(response).to(render_template :edit) 
                end
                it 'should set an instance variable idea for the object to edit' do
                    expect(assigns :idea).to eq(@idea)
                end
            end

            context 'as non-owner' do
                before do
                    @idea = FactoryBot.create(:idea)
                    get(:edit, params: { id: @idea.id })
                end

                it 'redirects to idea show' do
                    expect(response).to redirect_to(idea_path(@idea))
                end
                it 'sets a flash danger' do
                    expect(flash[:danger]).to be
                end
                it 'does not remove an idea' do
                    expect(Idea.find_by(id: @idea.id)).to eq(@idea)
                end
            end

        end

        context 'with no user signed in' do
            before do
                @idea = FactoryBot.create(:idea)
                current_user = nil
                get(:edit, params: { id: @idea.id })
            end
            
            it 'should redirect to session#new' do
                expect(response).to redirect_to(new_session_path)
            end

            it 'should send a flash danger message' do
                expect(flash[:danger]).to be
            end
        end


    end

    describe '#update' do
        before do
            session[:user_id] = current_user.id
            @idea = FactoryBot.create(:idea, user: current_user)
        end

        context 'with user signed in' do
            context 'with valid parameters' do
                before do
                    @new_title = "New Title"
                    patch :update, params: { id: @idea.id, idea: { title: @new_title }}
                end

                it 'should update the idea in the db' do
                    expect(@idea.reload.title).to eq(@new_title)
                end
                it 'should redirect to the show page of that idea' do
                    expect(response).to redirect_to(idea_path @idea)
                end
            end

            context 'with invalid parameters' do
                def invalid_request
                    patch :update, params: { id: @idea.id, idea: { title: nil }}
                end

                it "should not update idea" do
                    expect { invalid_request }.not_to change { @idea.reload.title }
                end

                it "should render the edit template" do
                    invalid_request
                    expect(response).to render_template(:edit)
                end
            end
        end

        context 'with no user signed in' do
            before do
                @idea = FactoryBot.create(:idea)
                current_user = nil
                patch :update, params: { id: @idea.id, idea: { title: "New Title" }}
            end
            
            it 'should redirect to session#new' do
                expect(response).to redirect_to(new_session_path)
            end

            it 'should send a flash danger message' do
                expect(flash[:danger]).to be
            end
        end
    end

end
