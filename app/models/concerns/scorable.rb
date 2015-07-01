module Scorable

  extend ActiveSupport::Concern

  class_methods do

    include Rails.application.routes.url_helpers

    # load top 20 users/ideas/feedbacks
    def popular_20
      self.fetch_multi(self.leaderboard.revrange(0, 20))
      .map{|object| send("#{self.to_s.downcase}_json", object)}
    end

    # load top 20 users/ideas/feedbacks
    def trending_20
      self.fetch_multi(self.trending.revrange(0, 20))
      .map{|object| send("#{self.to_s.downcase}_json", object)}
    end

    # load top 20 users/ideas/feedbacks
    def latest_listing
      self.fetch_multi(self.latest.revrange(0, 20))
      .map{|object| send("#{self.to_s.downcase}_json", object)}
    end

    #User JSON
    def user_json(user)
      {
        id: user.uid,
        name: user.name,
        name_badge: user.user_name_badge,
        avatar: user.avatar.url(:avatar),
        url: profile_path(user),
        description: user.mini_bio
      }
    end

    #Idea JSON
    def idea_json(idea)
      {
        id: idea.uuid,
        name: idea.name,
        name_badge: idea.name_badge,
        url: idea_path(idea),
        description: idea.high_concept_pitch
      }
    end

  end

end