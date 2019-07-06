Rails.application.routes.draw do
  root to: "home#top"

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks", #コールバック
    registrations: "users/registrations", #登録
    confirmations: "users/confirmations", #確認メール
    sessions: "users/sessions", #セッション
    passwords: "users/passwords", #パスワード
    unlocks: "users/unlocks" #ロック解除
  }

  devise_scope :user do
    get "login", to: "users/sessions#new", as: :login_get # ログインページ
    post "login/:id", to: "users/sessions#create", as: :login_post # ログイン
    delete "logout/:id", to: "users/sessions#destroy", as: :logout # ログアウト
    get "signup", to: "users/registrations#new", as: :signup_get # 新規登録ページ
    post "signup/:id", to: "users/registrations#create", as: :signup_post # 新規登録
    get "users/:id/edit", to: "users/registrations#edit", param: :id, as: :edit_user # ユーザー編集ページ
    put "users/:id/update", to: "users/registrations#update", param: :id, as: :update_user # ユーザーアップデート
    delete "users/:id/destroy", to: "users/registrations#destroy", as: :destroy_user # ユーザー削除
    get "password", to: "users/passwords#new", as: :new_password # パスワード忘れたページ
    post "password", to: "users/passwords#create", as: :password # パスワードリセットメールの送信
    get "password/:id/edit", to: "users/passwords#edit", param: :id, as: :edit_password # パスワードの再発行ページ
    patch "password/:id/update", to: "users/passwords#update", param: :id
    put "password/:id/update", to: "users/passwords#update", param: :id, as: :update_password # パスワード再発行
    get "confirmation", to: "users/confirmations#new", as: :new_confirmation # 確認メール届かなかったページ
    post "confirmation", to: "users/confirmations#create", as: :confirmation # 確認メールの再送信
    get "confirmation/:id/check", to: "users/confirmations#show", param: :id, as: :check_confirmation # 確認メールを確認したことを確認するURL
    get "unlock", to: "users/unlocks#new", as: :new_unlock # ロック解除ページ
    post "unlock", to: "users/unlocks#create", as: :unlock # ロック解除のメールを送信
    get "unlock/:code/check", to: "users/unlocks#show", param: :code, as: :check_unlock # ロック解除
  end

  get "users", to: "users#index", as: :users # ユーザー一覧
  get "users/:id", to: "users#show", param: :id, as: :user # プロフィール画面

  resources :posts 
  post "good_press/:post_id", to: "pressures#good", as: :good_press # Good
  post "bad_press/:post_id", to: "pressures#bad", as: :bad_press # Bad
  delete "/press/:post_id", to: "pressures#destroy", as: :reset_press # Good取り消し or Bad取り消し
  get "dead_posts", to: "posts#dead_posts", as: :dead_posts # 死亡したポスト一覧
  delete "all_destroy", to: "posts#all_destroy", as: :all_destroy # 死亡したポストの一括削除
  get "ranking", to: "posts#ranking", as: :ranking # スコアランキング

end
