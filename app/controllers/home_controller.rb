class HomeController < ApplicationController
  def top
    @posts = Post.where(live:true).shuffle[0..100]
  end
end
