class BadgesController < ApplicationController

  before_action :authenticate_user!

  layout "home"

  def show
    @badge = Merit::Badge.by_name(params[:id]).first
    if @badge.custom_fields[:type] == "user"
      @users = @badge.custom_fields[:type].titlecase.constantize
      .where(sash_id: Merit::BadgesSash.where(badge_id: @badge.id).pluck(:sash_id))
      .paginate(:page => params[:page], :per_page => 10)
      render :users
    elsif @badge.custom_fields[:type] == "user"
      @ideas = @badge.custom_fields[:type].titlecase.constantize
      .where(sash_id: Merit::BadgesSash.where(badge_id: @badge.id).pluck(:sash_id))
      .paginate(:page => params[:page], :per_page => 10)
      render :ideas
    end
  end
end
