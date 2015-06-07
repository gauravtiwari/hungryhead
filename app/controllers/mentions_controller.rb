class MentionsController < ApplicationController
  before_filter :authenticate_user!

  def mentionables
    @mentionable = params[:mentionable_type].constantize.find(params[:id])

    if params[:mentionable_type] == "Idea"
      mentionable_user = @mentionable.student
    else
      mentionable_user = @mentionable.user
    end

    commenters = @mentionable.commenters_ids.values

    ids = commenters - [current_user.id] - [mentionable_user.id]

    @mentionables = Rails.cache.fetch("#{params[:mentionable_type].downcase}-#{@mentionable.comments_counter}-mentions", expires: 2.hours) do
      User.find(ids).map { |user|
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
