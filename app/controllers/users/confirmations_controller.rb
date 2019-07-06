class Users::ConfirmationsController < Devise::ConfirmationsController

  def new
    super
  end

  def create
    super
  end

  def show
    super
  end
  private
  # 確認メールを再送したあとのリダイレクト先
  def after_resending_confirmation_instructions_path_for(resource_name)
    flash[:notice] = "確認メールを再送したのでもう一度確認してください。"
    login_get_path
  end

  # 確認メールを確認したあとのリダイレクト先
  def after_confirmation_path_for(resource_name, resource)
      flash[:notice] = nil
      flash[:success] = "HELLO"
      sign_in(resource)
      user_path(current_user.id)
  end
end
