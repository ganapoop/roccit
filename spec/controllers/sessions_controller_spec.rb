require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
let(:my_user) {User.create!(name: "Blochead", email: "blochead@bloc.io", password: "password") }

  describe "GET new" do
    it "returns https status" do
      get :new
      expect(response).to have_http_status(:success)
  end
end

  describe "POST sessions" do
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "initalizes a session" do
      post :create, session: {email: my_user.email, password: my_user.password}
      expect(sessions[:user_id]).to eq my_user.id
    end

    it "does not add a user id to session due to missing password" do
      post :create, sessions: {email: my_user.email}
      expect(sessions[:user_id]).to be_nil
    end

    it "flashes #error with bad email address" do
      post :create, session: {email: "does not exist"}
      expect(flash.now[:alert]).to be_present
    end

    it "renders #new with bad email address" do
      post :create, session: {email: "does not exist"}
      expect(response).to render_template :new
    end

    it "redirects to the root view" do
      post :create, session: {email: my_user.email, password: my_user.password}
       expect(response).to redirect_to(root_path)
    end
  end

  describe "DELETE sessions/id" do
    it "renders the #welcome view" do
      delete :destroy, id: my_user.id
      expect(response).to redirect_to root_path
    end

    it "deletes the user's sessions" do
      delete :destroy, id: my_user.id
      expect(assigns(:session)).to be_nil
    end

    it "flashes #notice" do
      delete :destroy, id: my_user.id
      expect(flash[:notice]).to be_present
    end
    it "logs the user in after sign up" do
      post :create, user: new_user_attributes
      expect(session[:user_id]).to eq assigns(:user).id
    end
  end
end
