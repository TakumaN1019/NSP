class Users::RegistrationsController < Devise::RegistrationsController

  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy] # 投稿者でなければリダイレクト>ではじく

  def new
    super
  end

  def create
    super
  end

  #ユーザープロフィールの編集
  def edit
    @title = "ユーザー編集"
  end

  def update
    # パスワードが空であればpasswordカラムをバリデーションしない
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end

    if @user.update(user_params)
      flash[:success] = "UPDATE"
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  def destroy
    flash[:notice] = nil
    flash[:success] = "DELETE"
    super
  end

  # ユーザー登録した直後のリダイレクト先を指定
  def after_sign_up_path_for(resource)
    flash[:success] = "WELCOME"
    login_get_path
  end

  # 確認メール送信後のリダイレクト先を指定
  def after_inactive_sign_up_path_for(resource)
    flash[:notice] = "確認メールを送信したのでメール内のリンクから登録を完了させましょう。"
    login_get_path
  end

  private

    def set_user
      @user = User.find_by(id: params[:id])
    end

    def user_params
      params.require(:user).permit(:image, :image_cache, :name, :email, :provider, :uid, :password, :password_confirmation)
    end

    # 他人のページにアクセスしようとしたらリダイレクトではじく
    def ensure_correct_user
      @user = User.find_by(id: params[:id])
      if not current_user.id == @user.id
        flash[:alert] = "権限がないのでアクセスできません。"
        redirect_to user_path(current_user.id)
      end
    end

end

