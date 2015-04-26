class MentionsController < ApplicationController
  before_filter :authenticate_user!

  def mentionables
    @mentionable = params[:mentionable_type].constantize.find(params[:id])
    if @mentionable.class.to_s == "Idea"
      mentionable = @mentionable.student
    else
      mentionable = @mentionable.user
    end
    @mentionables = Array.new
    @mentionables.push(name: mentionable.name, path: user_path(mentionable), username: mentionable.username) if mentionable != current_user
    @mentionable.comment_threads.includes(:user).map { |c| @mentionables.push({id: c.user.id, name: c.user.name, username: c.user.username, path: profile_url(c.user)}) unless @mentionables.include?({id: c.user.id, name: c.user.name, username: c.user.username, path: profile_url(c.user)}) && c.user == current_user }
    render json: @mentionables
  end

end
