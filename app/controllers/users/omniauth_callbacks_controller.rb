class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    callback_from :twitter
  end
  def google_oauth2
    callback_from :google
  end
  def facebook
    callback_from :facebook
  end

  private
  def callback_from(provider)
    provider = provider.to_s
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user.persisted?
      flash[:notice] = nil
      flash[:success] = "HELLO"
      @user.skip_confirmation! #SNS認証の場合はメール確認のプロセスをスキップする
      sign_in(@user)
      redirect_to user_path(@user.id)
    else
      session["devise.#{provider}_data"] = request.env['omniauth.auth']
      redirect_to new_user_registration_path
    end
  end

end
