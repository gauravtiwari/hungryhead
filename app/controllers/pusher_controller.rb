class PusherController < ApplicationController
  before_filter :authenticate_user!
  protect_from_forgery except: :auth

  def auth
    if current_user
      response = Pusher[params[:channel_name]].authenticate(params[:socket_id], user_id: current_user.uid,
                                                                                user_info: {
                                                                                  user_id: current_user.uid,
                                                                                  name: current_user.name,
                                                                                  name_badge: current_user.name_badge,
                                                                                  email: current_user.email,
                                                                                  avatar: current_user.get_avatar,
                                                                                  url: profile_path(current_user)
                                                                                })
      render json: response
    else
      render text: 'Not authorized', status: '403'
    end
  end
end
