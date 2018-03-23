class SearchController < ApplicationController
def index
    if params[:query].present?
      @post = Post.search(params[:query], show: params[:show])
    else
      @post = Post.all
    end
end
end
