class MentionsController < ApplicationController
  before_filter :authenticate_user!

  def mentionables
    @mentionable = params[:mentionable_type].constantize.find_by_uuid(params[:id])

    mentionable_user = @mentionable.user

    commenters = @mentionable.commenters_ids.values

    ids = (commenters + [mentionable_user.id.to_s])

    ids.delete(current_user.id.to_s)

    @mentionables = Rails.cache.fetch("#{params[:mentionable_type].downcase}-#{@mentionable.comments_counter}-#{@mentionable.uuid}-mentions-#{current_user.uid}", expires: 2.hours) do
      User.find(ids.uniq).map { |user|
        {
          id: user.uid,
          name: user.name,
          username: user.username
        }
      }
    end
    render json: @mentionables
  end

end
