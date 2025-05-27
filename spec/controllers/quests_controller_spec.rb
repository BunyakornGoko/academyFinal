require 'rails_helper'

RSpec.describe QuestsController, type: :controller do
  let(:valid_attributes) { { name: 'Test Quest', status: false } }
  let(:invalid_attributes) { { name: '', status: nil } }
  let(:quest) { create(:quest, valid_attributes) }

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns all quests to @quests" do
      quests = create_list(:quest, 3)
      get :index
      expect(assigns(:quests)).to match_array(quests)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
    end

    it "assigns a new quest to @quest" do
      get :new
      expect(assigns(:quest)).to be_a_new(Quest)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new Quest" do
        expect {
          post :create, params: { quest: valid_attributes }
        }.to change(Quest, :count).by(1)
      end


      it "returns created status with JSON format" do
        post :create, format: :json, params: { quest: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
      end
    end

    context "with invalid parameters" do
      it "does not create a new Quest" do
        expect {
          post :create, params: { quest: invalid_attributes }
        }.not_to change(Quest, :count)
      end

      it "renders new template with unprocessable entity status for HTML format" do
        post :create, params: { quest: invalid_attributes }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns unprocessable entity status with JSON format" do
        post :create, format: :json, params: { quest: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested quest" do
      quest_to_delete = create(:quest)
      expect {
        delete :destroy, params: { id: quest_to_delete.id }
      }.to change(Quest, :count).by(-1)
    end

    it "redirects to the quests list with HTML format" do
      delete :destroy, params: { id: quest.id }
      expect(response).to redirect_to(quests_path)
      expect(flash[:notice]).to eq("Quest was successfully destroyed.")
    end

    it "returns no content with JSON format" do
      delete :destroy, format: :json, params: { id: quest.id }
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "POST #toggle_status" do
    it "toggles the quest status" do
      expect {
        post :toggle_status, params: { id: quest.id }
      }.to change { quest.reload.status }.from(false).to(true)
    end

    it "renders turbo stream for turbo_stream format" do
      post :toggle_status, format: :turbo_stream, params: { id: quest.id }
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('text/vnd.turbo-stream.html')
    end
  end
end
