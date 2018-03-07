class PostsController < ApplicationController
    
    def index
        @post = Post.all.order('created_at DESC')
    end 
    
    def show
        @post = Post.find(params[:id])
    end
    
    def new
    if user_signed_in?
        @post = current_user.posts.build
    else
        redirect_to '/users/sign_in'
    end 
    end 
    
    def create
        @post = current_user.posts.build(post_params)
        if @post.save
            redirect_to @post
        else 
            render 'new'
        end 
    end 
    
    def edit 
        @post = Post.find(params[:id])
    end 
    
    def update
    @post = Post.new(post_params)
        if @post.update(post_params)
            redirect_to @post
        else 
            render 'edit'
        end  
    end 
    
    def destroy
         @post = Post.find(params[:id])
         @post.destroy
         
         redirect_to posts_path
    end 
    
    private 
        def post_params
            params.require(:post).permit(:title, :body)
        end 
        
    
            
    
end
