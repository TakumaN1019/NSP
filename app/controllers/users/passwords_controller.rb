class Users::PasswordsController < Devise::PasswordsController

  def new
    super
  end

  def create
    super
  end
  def edit
    @title = "パスワード変更"
    super
  end

  def update
    super
  end

  protected
    def set_user
      @user = User.find_by(code: params[:id])
    end

    # パスワードリセット後のリダイレクト先
    def after_resetting_password_path_for(resource)
      flash[:notice] = nil
      flash[:success] = "SUCCESS"
      user_path(current_user.id)
    end

    # The path used after sending reset password instructions
    # パスワードリセットのメールを送信したあとのリダイレクト先
    def after_sending_reset_password_instructions_path_for(resource_name)
      flash[:notice] = "パスワードリセットのメールを送信したので確認してください。"
      super(resource_name)
    end


end
