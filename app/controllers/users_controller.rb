class UsersController < ApplicationController

  before_action :set_user, only: [:show]

  def index
    @title = "ユーザー一覧"
    @users = User.all.order(score: :desc).take(100)
    @users_count = User.all.count
  end

  def show
    @posts = Post.where(user_id:@user.id, live:true).order(updated_at: :desc)
  end

  private
    def set_user
      @user = User.find_by(id: params[:id])
    end

end
