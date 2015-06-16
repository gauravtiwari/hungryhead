class MentionsController < ApplicationController
  before_filter :authenticate_user!

  def mentionables
    @mentionable = params[:mentionable_type].constantize.find(params[:id])

    mentionable_user = @mentionable.user

    commenters = @mentionable.commenters_ids.values.uniq

    ids = (commenters + [mentionable_user.id]).uniq

    ids.delete(current_user.id.to_s)
    uniq_ids = ids.uniq

    @mentionables = Rails.cache.fetch("#{params[:mentionable_type].downcase}-#{@mentionable.comments_counter}-mentions", expires: 2.hours) do
      User.find(uniq_ids).map { |user|
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
