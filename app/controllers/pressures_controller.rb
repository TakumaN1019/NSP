class PressuresController < ApplicationController

  after_action :natural_selection, only: [:good, :bad, :destroy]

  def good
    @post=Post.find_by(id: params[:post_id])
    @pressure = Pressure.find_by(user_id:current_user.id, post_id:@post.id)
    if @pressure.present?
      @pressure.update(direction:"good")
    else
      @pressure = Pressure.create(user_id:current_user.id, post_id:@post.id, direction:"good")
    end
    @posts = Post.where(live:true).order(created_at: :desc)
  end

  def bad
    @post=Post.find_by(id: params[:post_id])
    @pressure = Pressure.find_by(user_id:current_user.id, post_id:@post.id)
    if @pressure.present?
      @pressure.update(direction:"bad")
    else
      @pressure = Pressure.create(user_id:current_user.id, post_id:@post.id, direction:"bad")
    end
    @posts = Post.where(live:true).order(created_at: :desc)
  end

  def destroy
    @post=Post.find_by(id: params[:post_id])
    @pressure = Pressure.find_by(user_id:current_user.id, post_id:@post.id)
    @pressure.delete if @pressure.present?
    @pressure = ""
    @posts = Post.where(live:true).order(created_at: :desc)
  end


  private

    def natural_selection
    # @postのスコアに反映
    press = Pressure.where(post_id:@post.id)
    goods = press.where(post_id:@post.id, direction:"good")
    bads = press.where(post_id:@post.id, direction:"bad")

    good_sum = 0
    goods.each do |good|
      user = User.find(good.user_id) # goodしたユーザー
      user.score = 50 if user.score == 0
      good_sum += user.score.to_i  # ユーザースコアの重み(0~100)、そのユーザーの評価の重要度
    end

    bad_sum = 0
    bads.each do |bad|
      user = User.find(bad.user_id) # goodしたユーザー
      user.score = 50 if user.score == 0
      bad_sum += user.score.to_i # ユーザースコアの重み(0~100)、そのユーザーの評価の重要度
    end

    max_score = press.count.to_i * 100 # 評価した全てのユーザーのユーザースコアが100で、全員が高評価した場合にとりうる最大のスコア
    good_ratio = max_score.to_i > 0 ? good_sum.to_i / max_score.to_i.to_f * 100 : 0 # マックススコアと実際の重み付けされた高評価の割合
    bad_ratio = max_score.to_i > 0 ? bad_sum.to_i / max_score.to_i.to_f * 100 : 0 # マックススコアと実際の重み付けされた低評価の割合

    weight_range = good_ratio.to_i + bad_ratio.to_i # 重み付けされた高評価と低評価の割合の合計値
    weight_good_ratio = weight_range.to_i > 0 ? good_ratio.to_i / weight_range.to_i.to_f * 100 : 0 # 重み付けされた高評価と低評価の割合の合計値の内、重み付けされた高評価の割合
    weight_bad_ratio = weight_range.to_i > 0 ? bad_ratio.to_i / weight_range.to_i.to_f * 100 : 0 # 重み付けされた高評価と低評価の割合の合計値の内、重み付けされた高評価の割合

    post_score = weight_good_ratio
    @post.update(score:post_score)


    # @post.userのスコアに反映
    posts = Post.where(user_id:@post.user.id)
    total_score = posts.sum(:score)
    user_score = posts.count.to_i > 0 ? total_score.to_i / posts.count.to_i.to_f : 0
    @post.user.update(score:user_score)

    # 生死判定(投稿してから100時間経過していてスコアが30以下のポストは排除)
    #elapsed_date = (@post.created_at.to_date - Date.today).to_i * -1 # 投稿してから経過した日数
    elapsed_time = (@post.created_at.to_time - DateTime.now).to_i.to_f / 60.to_f / 60.to_f * -1 # 投稿してから経過した時間
    post_score = @post.score
    if elapsed_time >= 100 && post_score <= 30
      @post.update(live:false)
    end

    end
end
