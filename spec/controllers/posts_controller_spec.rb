require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  # #8
  let(:my_post) { Post.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph) }

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "assigns [my_post] to @posts" do
      get :index
      # #9
      expect(assigns(:posts)).to eq([my_post])
    end
  end

  describe "GET show" do
    let(:params) { { id: my_post.id } }

    def do_request
      get :show, params: params
    end

    it "returns http success" do
      do_request

      expect(response).to have_http_status(:success)
    end

    it "renders the #show view" do
      do_request

      expect(response).to render_template :show
    end

    it "assigns my_post to @post" do
      do_request

      expect(assigns[:post]).to eq(my_post)
    end
  end

  describe "GET new" do
    it "returns http success" do
      get :new

      expect(response).to have_http_status(:success)
    end

    # #2
    it "renders the #new view" do
      get :new

      expect(response).to render_template :new
    end

    # #3
    it "instantiates @post" do
      get :new

      expect(assigns(:post)).not_to be_nil
    end
  end

  describe "POST create" do
    # #4
    it "increases the number of Post by 1" do
      expect{post :create, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph}}.to change(Post,:count).by(1)
    end

    # #5
    it "assigns the new post to @post" do
      post :create, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
      expect(assigns[:post]).to eq Post.last
    end

    # #6
    it "redirects to the new post" do
      post :create, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
      expect(response).to redirect_to Post.last
    end
  end

  describe "GET edit" do
    it "returns http success" do
      get :edit, { {id: my_post.id} }
      expect(response).to have_http_status(:success)
    end
    it "renders the #edit view" do
      get :edit,  { {id: my_post.id} }
      expect(response).to render_template :edit
    end
    it "assigns post to be updated to @post" do
      get :edit, { {id: my_post.id} }
      post_instance = assigns(:post)
      expect(post_instance.id).to eq my_post.id
      expect(post_instance.title).to eq my_post.title
      expect(post_instance.body).to eq my_post.body
    end
  end

  describe "DELETE destroy" do
    it "deletes the post" do
      delete :destroy, {id: my_post.id}
      count = Post.where({id: my_post.id}).size
      expect(count).to eq 0
    end

    it "redirects to posts index" do
      delete :destroy, {id: my_post.id}
      expect(response).to redirect_to posts_path
    end
  end
end
