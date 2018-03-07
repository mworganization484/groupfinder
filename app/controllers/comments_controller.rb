class CommentsController < ApplicationController
    def create
        @post = Post.find(params[:post_id])
    if user_signed_in?
        @comments = @post.comments.create(comment_params)
        redirect_to post_path(@post)
    else 
        redirect_to '/users/sign_in'
    end
    end 
    
    private def comment_params 
        params.require(:comment).permit(:username, :body)
    end 
end
