class MicropostsController < ApplicationController
  #include MicropostsHelper
  before_filter :signed_in_user, :only=> [:destroy]
  before_filter :current_user, :only=> :destroy

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def vote

    begin
    value = 1
    @micropost = Micropost.find(params[:id])
    @micropost.add_evaluation(:votes, value, current_user)
    redirect_to :back
    rescue
    redirect_to :back
    end
  end

  def boo
    value = 1
    @micropost = Micropost.find(params[:id])
    @micropost.decrease_evaluation(:votes, value, current_user)
    @micropost.has_evaluation?(:votes, current_user)
    redirect_to :back
  end

  def destroy
    Micropost.find(params[:id]).destroy
    redirect_to root_path
  end
  private
  def correct_user
    @micropost = current_user.microposts.find_by_id(params[:id])
    redirect_to root_path if @micropost.nil?
  end

  def add_comment
  commentable_type = params[:commentable][:commentable]
  commentable_id = params[:commentable][:commentable_id]
  # Get the object that you want to comment
  commentable = Comment.find_commentable(commentable_type, commentable_id)

  # Create a comment with the user submitted content
  comment = Comment.new(params[:comment])
  # Assign this comment to the logged in user
  comment.user_id = session[:user].id

  # Add the comment
  commentable.comments << comment

  redirect_to :action => commentable_type.downcase,
    :id => commentable_id
end

end
