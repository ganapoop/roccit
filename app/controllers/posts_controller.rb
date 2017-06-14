class PostsController < ApplicationController

  before_action :require_sign_in, except: :show
  before_action :authorize_user, except: [:show, :new, :create]

  def show
    @post = Post.find(params[:id])
  end

  def new
    @topic = Topic.find(params[:topic_id])
    @post = Post.new
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.build(post_params)
    @post.user = current_user

    if @post.save

      flash[:notice] = "Post was saved."
      redirect_to [@topic, @post]
    else
      flash.now[:alert] = "There was an error saving the post. Please try again."
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end
  def update
    @post = Post.find(params[:id])
    @post.assign_attributes(post_params)

    if @post.save
      flash[:notice] = "Post was update"
      redirect_to [@post.topic, @post]
    else
      flash.now[:alert] = "There was an error saving the post. Please try again."
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      flash[:notice] = "\"#{@post.title}\" was deleted successfully."
      redirect_to @post.topic
    else
      flash.now[:alert] = "There was an error deleting the post."
      render :show
    end
  end
  private

  def post_params
    params.require(:post).permit(:title, :body)
  end

  def authorize_user
    post = Post.find(params[:id])

    unless current_user == post.user || current_user.admin? || current_user.moderator?
      flash[:alert] = "You must be an admin to do that."
      redirect_to [post.topic, post]
    end
  end
  context "moderator user doing CRUD on a post they don't own" do
    before do
      other_user.moderator!
      create_session(other_user)
    end

    describe "GET show" do
      it "returns http success" do
        get :show, topic_id: my_topic.id, id: my_post.id
        expect(response).to have_http_status(:success)
      end

      it "renders the #show view" do
        get :show, topic_id: my_topic.id, id: my_post.id
        expect(response).to render_template :show
      end

      it "assigns my_post to @post" do
        get :show, topic_id: my_topic.id, id: my_post.id
        expect(assigns(:post)).to eq(my_post)
      end
    end

    describe "GET new" do
      it "returns http success" do
        get :new, topic_id: my_topic.id
        expect(response).to have_http_status(:success)
      end

      it "renders the #new view" do
        get :new, topic_id: my_topic.id
        expect(response).to render_template :new
      end

      it "instantiates @post" do
        get :new, topic_id: my_topic.id
        expect(assigns(:post)).not_to be_nil
      end
    end

    describe "POST create" do
      it "increases the number of Post by 1" do
        expect{ post :create, topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph} }.to change(Post,:count).by(1)
      end

      it "assigns the new post to @post" do
        post :create, topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect(assigns(:post)).to eq Post.last
      end

      it "redirects to the new post" do
        post :create, topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect(response).to redirect_to [my_topic, Post.last]
      end
    end

    describe "GET edit" do
      it "returns http success" do
        get :edit, topic_id: my_topic.id, id: my_post.id
        expect(response).to have_http_status(:success)
      end

      it "renders the #edit view" do
        get :edit, topic_id: my_topic.id, id: my_post.id
        expect(response).to render_template :edit
      end

      it "assigns post to be updated to @post" do
        get :edit, topic_id: my_topic.id, id: my_post.id
        post_instance = assigns(:post)

        expect(post_instance.id).to eq my_post.id
        expect(post_instance.title).to eq my_post.title
        expect(post_instance.body).to eq my_post.body
      end
    end

    describe "PUT update" do
      it "updates post with expected attributes" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, topic_id: my_topic.id, id: my_post.id, post: {title: new_title, body: new_body}

        updated_post = assigns(:post)
        expect(updated_post.id).to eq my_post.id
        expect(updated_post.title).to eq new_title
        expect(updated_post.body).to eq new_body
      end

      it "redirects to the updated post" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, topic_id: my_topic.id, id: my_post.id, post: {title: new_title, body: new_body}
        expect(response).to redirect_to [my_topic, my_post]
      end
    end

    describe "DELETE destroy" do
      it "returns http redirect" do
        delete :destroy, topic_id: my_topic.id, id: my_post.id
        expect(response).to redirect_to my_topic
      end
    end
  end
