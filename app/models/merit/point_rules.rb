# Be sure to restart your server when you modify this file.
#
# Points are a simple integer value which are given to "meritable" resources
# according to rules in +app/models/merit/point_rules.rb+. They are given on
# actions-triggered, either to the action user or to the method (or array of
# methods) defined in the +:to+ option.
#
# 'score' method may accept a block which evaluates to boolean
# (recieves the object as parameter)

module Merit
  class PointRules
    include Merit::PointRulesMethods

    def initialize

      negative_score = -5

      #Users related scoring
      score 5, :on => 'users#update', category: 'autobiographer' do |user|
        user.about_me.present? && user.points(category: 'autobiographer') == 0
      end

      #Comments related
      score 5, :on => 'comments#create', category: 'comment', to: :commentable do |comment|
        comment.commentable_user != comment.user
      end

      score negative_score, :on => 'comments#destroy', category: 'comment', to: :commentable do |comment|
        comment.commentable_user != comment.user
      end

      #Feedbacks related
      score 25, :on => 'feedbacks#create', category: 'feedback', to: :idea

      #Rate feedback
      score 25, :on => 'feedbacks#rate', to: :user, category: 'feedback' do |feedback|
        feedback.badged? && feedback.helpful?
      end

      score negative_score, :on => 'feedbacks#rate', to: :user, category: 'feedback' do |feedback|
        feedback.badged? && feedback.irrelevant?
      end

      #Feedback rate
      score 5, :on => 'feedbacks#rate', to: :idea_owner, category: 'user' do |feedback|
        feedback.badged?
      end

      #Investment related
      score 25, :on => 'investments#create', to: [:user, :idea], category: 'investment'

      #Ideas
      score 5, :on => 'ideas#publish', to: :user, category: 'idea_publish' do |idea|
        idea.user.points(category: 'idea_publish') == 0 && idea.published?
      end

      score negative_score, :on => 'ideas#unpublish', to: :user, category: 'idea_publish' do |idea|
        idea.draft?
      end

      #Votes
      score 5, :on => 'votes#vote', to: [:votable, :votable_user], category: 'vote' do |vote|
        vote.votable_type != "Investment" && vote.voter != vote.votable_user
      end

      score negative_score, :on => 'votes#unvote', to: [:votable, :votable_user], category: 'vote' do |vote|
        vote.votable_type != "Investment" && vote.voter != vote.votable_user
      end

    end
  end
end
