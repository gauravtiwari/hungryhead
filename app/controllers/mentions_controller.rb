class MentionsController < ApplicationController
  before_filter :authenticate_user!

  def mentionables
    @mentionable = params[:mentionable_type].constantize.fetch_by_uuid(params[:id])

    mentionable_user = @mentionable.fetch_user

    commenters = @mentionable.commenters_ids.values

    ids = (commenters + [mentionable_user.id.to_s])

    ids.delete(current_user.id.to_s)

    User.fetch_multi(ids.uniq).map { |user|
      {
        id: user.uid,
        name: user.name,
        username: user.username
      }
    }
    render json: @mentionables
  end

end
