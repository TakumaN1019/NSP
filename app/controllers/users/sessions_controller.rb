class Users::SessionsController < Devise::SessionsController

  def new
    super
  end
  def create
    super
  end

  def destroy
    super
  end


  # ログイン後のリダイレクト先を指定
  def after_sign_in_path_for(resource)
    flash[:notice] = nil
    flash[:success] = "HELLO"
    user_path(current_user.id)
  end
  # ログアウト後の遷移するページの指定
  def after_sign_out_path_for(resource)
    flash[:notice] = nil
    flash[:success] = "GOODBYE"
    root_path
  end

end
