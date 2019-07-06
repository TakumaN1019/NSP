class Users::UnlocksController < Devise::UnlocksController
  def new
    super
  end

  def create
    super
  end

  def show
    super
  end

  protected
    # ロック解除のメール送信後のリダイレクト先
    def after_sending_unlock_instructions_path_for(resource)
      flash[:notice] = "ロック解除のメールを送ったので確認してください。"
      login_get_path
    end

    # ロック解除後のリダイレクト先
    def after_unlock_path_for(resource)
      flash[:notice] = "ロックを解除しました。"
      login_get_path
    end

end
