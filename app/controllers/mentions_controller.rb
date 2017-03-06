class MentionsController < ApplicationController
  #  Set before filter
  before_filter :authenticate_user!

  def mentionables
    # Find mentionable by uuid
    @mentionable = params[:mentionable_type].constantize.find_by_uuid(params[:id])

    # Find mentionable user
    mentionable_user = @mentionable.user

    # Find people who commented on a commentable
    commenters = @mentionable.commenters_ids.values
    mentionable_ids = (commenters + [mentionable_user.id.to_s])

    # Delete current_user from mentionable
    mentionable_ids.delete(current_user.id.to_s)

    @mentionables = User.find(mentionable_ids.uniq).map do |user|
      {
        id: user.uid,
        name: user.name,
        username: user.username
      }
    end
    render json: @mentionables
  end
end
