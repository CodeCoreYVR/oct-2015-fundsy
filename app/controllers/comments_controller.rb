class CommentsController < ApplicationController
  before_action :find_commentable

  def create
    @comment             = Comment.new comment_params
    @comment.commentable = @commentable
    if @comment.save
      redirect_to @commentable, notice: "Comment saved"
    else
      model_folder = @commentable.class.name.underscore.pluralize
      render "/#{model_folder}/show"
    end
  end

  private

  def find_commentable
    if params[:campaign_id]
      @campaign = @commentable = Campaign.find params[:campaign_id]
    elsif params[:discussion_id]
      @discussion = @commentable = Discussion.find params[:discussion_id]
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

end
