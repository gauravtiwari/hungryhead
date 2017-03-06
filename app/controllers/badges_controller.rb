class BadgesController < ApplicationController
  before_action :authenticate_user!, :find_badged
  layout 'home'

  def show
    if @badge.custom_fields[:type] == 'user'
      @users = find_badged.paginate(page: params[:page], per_page: 10)
      render :users
    elsif @badge.custom_fields[:type] == 'idea'
      @ideas = find_badged.paginate(page: params[:page], per_page: 10)
      render :ideas
    end
  end

  private

  def find_badged
    @badge = Merit::Badge.by_name(params[:id]).first
    @badge.custom_fields[:type].titlecase.constantize
          .where(sash_id: Merit::BadgesSash.where(badge_id: @badge.id).pluck(:sash_id))
  end
end
