# Be sure to restart your server when you modify this file.
#
# +grant_on+ accepts:
# * Nothing (always grants)
# * A block which evaluates to boolean (recieves the object as parameter)
# * A block with a hash composed of methods to run on the target object with
#   expected values (+votes: 5+ for instance).
#
# +grant_on+ can have a +:to+ method name, which called over the target object
# should retrieve the object to badge (could be +:user+, +:self+, +:follower+,
# etc). If it's not defined merit will apply the badge to the user who
# triggered the action (:action_user by default). If it's :itself, it badges
# the created object (new user for instance).
#
# The :temporary option indicates that if the condition doesn't hold but the
# badge is granted, then it's removed. It's false by default (badges are kept
# forever).

module Merit
  class BadgeRules
    include Merit::BadgeRulesMethods

    def initialize

      #User related badges
      grant_on 'welcome#show', badge: 'community', :model_name => 'User' do |user|
        user.rules_accepted?
      end

      grant_on 'users#update', badge: 'autobiographer', to: :itself, temporary: true do |user|
        user.about_me.present?
      end

      grant_on 'welcome#show', badge: 'top-10', :model_name => 'User' do |user|
        user.id <= 10
      end

      grant_on 'welcome#show', badge: 'top-100', :model_name => 'User' do |user|
        user.id <= 100 && user.id > 10
      end

      grant_on 'welcome#show', badge: 'top-1000', :model_name => 'User' do |user|
        user.id <= 1000 && user.id > 100
      end

      grant_on 'welcome#show', badge: 'top-10000', :model_name => 'User' do |user|
        user.id <= 10000 && user.id > 1000
      end

      grant_on 'sessions#create', badge: 'enthusiast', :model_name => 'User' do |user|
        (user.updated_at - user.created_at).to_i == 30
      end

      grant_on 'sessions#create', badge: 'focussed', :model_name => 'User' do |user|
        (user.updated_at - user.created_at).to_i == 100
      end

      grant_on 'follows#create', badge: 'social', to: :follower do |follower|
        follower.followings_counter.value == 200
      end

      #Idea related badges

      grant_on 'ideas#publish', badge: 'student', to: :student do |idea|
        idea.student.ideas_counter.value == 1
      end

      grant_on 'ideas#publish', badge: 'lean', to: :student do |idea|
        idea.student.ideas_counter.value == 1 && Idea.leaderboard.score(idea.id) >= 5
      end

      grant_on 'ideas#publish', badge: 'entrepreneur', to: :student do |idea|
        Idea.leaderboard.score(idea.id) >= 200
      end

      #Share related badges
      grant_on 'shares#create', badge: 'growth-hacking', to: :user do |share|
        share.votes_counter.value >= 50
      end

      #Feedback related badges

      grant_on 'feedbacks#create', badge: 'feedbacker', to: :user do |feedback|
        feedback.user.feedbacks_counter.value >= 1
      end

      grant_on 'feedbacks#rate', badge: 'wise', to: :user do |feedback|
        feedback.user.helpful_feedbacks_counter >= 10
      end

      #Investment related bages
      grant_on 'investments#create', badge: 'investor', to: :user do |investment|
        investment.user.investments_counter.value >= 1
      end

      #Comments related badges

      grant_on 'comments#create', badge: 'commentator', to: :user do |comment|
        comment.user.comments_counter.value >= 10
      end

      grant_on 'comments#create', badge: 'outspoken', to: :user do |comment|
        comment.user.comments_counter.value >= 50
      end

      grant_on 'comments#create', badge: 'collaborative', to: :user do |comment|
        comment.user.comments_counter.value >= 50 &&  comment.user.comments_score >= 250
      end

      grant_on 'comments#create', badge: 'pundit', to: :user do |comment|
        comment.user.comments_counter.value >= 100 &&  comment.user.comments_score >= 1000
      end

      #votes related badges
      grant_on 'votes#vote', badge: 'early-adopter', to: :voter do |vote|
        vote.voter.count_idea_votes >= 10
      end

      #note related badges
      grant_on 'notes#create', badge: 'influencer', to: :user do |note|
        note.user.notes_counter.value >= 10 && note.notes_score >= 50
      end

    end

  end
end
