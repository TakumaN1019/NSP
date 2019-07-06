class Post < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :user

  # 選択圧
  has_many :pressures
  has_many :users, through: :pressures

  # オリジナルのカスタムバリデーション(日本語化するよりもこっちのほうが自由度が高いので良い)
  validate :add_error_post
  def add_error_post
    # 文章が入力されず、画像も選択されていない状態のときのエラーメッセージ
    if text.blank? && image.blank?
      errors[:base] << "投稿するポストが空です。"
    end

    # ユーザーネームが20文字以上のときのエラーメッセージ
    if text.length > 200
      errors[:base] << "文章は200文字以内にしてください。"
    end

  end

end

