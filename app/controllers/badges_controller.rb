class BadgesController < ApplicationController

  before_action :authenticate_user!

  layout "home"

  def show
    @badge = Merit::Badge.by_name(params[:id]).first
    @users = @badge.custom_fields[:type].titlecase.constantize.where(sash_id: Merit::BadgesSash.where(badge_id: @badge.id).pluck(:sash_id)).paginate(:page => params[:page], :per_page => 20)
  end

end
