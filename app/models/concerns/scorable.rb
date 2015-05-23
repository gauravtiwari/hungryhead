module Scorable

  extend ActiveSupport::Concern

  class_methods do
    include Rails.application.routes.url_helpers
    # load top 20 users/ideas/feedbacks
    def popular_20
      list = Redis::List.new("popular_20_#{self.to_s.downcase}", marshal: true)
      if list.empty?
        self.where(id: self.leaderboard.revrange(0, 20)).order_as_specified(id: self.leaderboard.revrange(0, 20)).each do |item|
          list << send("#{self.to_s.downcase}_json", item)
        end
      end
      list
    end

    # load top 20 users/ideas/feedbacks
    def trending_20
      list = Redis::List.new("trending_20_#{self.to_s.downcase}", marshal: true)
      if list.empty?
        self.where(id: self.trending.revrange(0, 20)).order_as_specified(id: self.trending.revrange(0, 20)).each do |item|
          list << send("#{self.to_s.downcase}_json", item)
        end
      end
      list
    end

    def latest_listing
      list = Redis::List.new("latest_listing_#{self.to_s.downcase}", marshal: true)
      if list.empty?
        self.where(id: self.latest.values.reverse).order_as_specified(id: self.latest.values.reverse).each do |item|
          list << send("#{self.to_s.downcase}_json", item)
        end
      end
      list
    end

    def user_json(user)
      {
        id: user.id,
        name: user.name,
        name_badge: user.user_name_badge,
        avatar: user.avatar.url(:avatar),
        url: profile_path(user),
        description: user.mini_bio
      }
    end

    def idea_json(idea)
      {
        id: idea.id,
        name: idea.name,
        name_badge: idea.name_badge,
        url: idea_path(idea),
        description: idea.elevator_pitch
      }
    end

  end

end