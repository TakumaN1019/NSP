class PostsController < ApplicationController

  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:dead_posts, :all_destroy, :new, :create, :edit, :update, :destroy] # deviseのヘルパーメソッド、デフォルトではログイン画面に遷移する
  before_action :ensure_correct_user, only: [:edit, :update, :destroy] # 管理者または投稿者でなければリダイレクトではじく
  before_action :takuman_only, only: [:dead_posts, :all_destroy] # 管理者でなければリダイレクトではじく

  def index
    @posts = Post.where(live:true).shuffle[0..100]
  end

  def ranking
    @posts = Post.where(live:true).order(score: :desc).take(100)
  end

  def dead_posts
    @posts = Post.where(live:false).order(created_at: :desc).shuffle[0..100]
  end

  def all_destroy
    posts = Post.where(live:false)
    posts.each do |post|
      post.destroy
    end
    flash[:success] = "一括削除しました"
    redirect_to dead_posts_path
  end

  def show
    if user_signed_in?
      @pressure = Pressure.find_by(user_id:current_user.id, post_id:@post.id)
    end
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      flash[:success] = "CREATE"
      redirect_to @post
    else
      render :new
    end
  end

  def update
    if @post.update(post_params)
      flash[:success] = "UPDATE"
      redirect_to @post
    else
      render :edit 
    end
  end

  def destroy
    @post.destroy
    flash[:success] = "DELETE"
    redirect_to user_path(current_user.id)
  end

  private
    def set_post
      @post = Post.find_by(id: params[:id])
    end

    def post_params
      params.require(:post).permit(:text, :image, :user_id)
    end

    # 管理者または投稿者でない場合はリダイレクトではじく
    def ensure_correct_user
      @post = Post.find_by(id: params[:id])
      if not current_user.id == 1
        if not current_user.id == @post.user.id
          flash[:alert] = "権限がないのでアクセスできません。"
          redirect_to timeline_path
        end
      end
    end

    def takuman_only
      if not current_user.id == 1
        flash[:alert] = "権限がないのでアクセスできません。"
        redirect_to user_path(current_user.id)
      end
    end

end
