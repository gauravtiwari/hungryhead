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

      grant_on 'sessions#create', badge: 'enthusiast', :model_name => 'User' do |user|
        (user.updated_at - user.created_at).to_i == 30
      end

      grant_on 'sessions#create', badge: 'focussed', :model_name => 'User' do |user|
        (user.updated_at - user.created_at).to_i == 100
      end

      grant_on 'follows#create', badge: 'social', to: :follower do |follower|
        follower.friends_count == 200
      end

      #Idea related badges

      grant_on 'ideas#publish', badge: 'lean', to: :student do |idea|
        idea.student.ideas_counter.value == 1 && Idea.leaderboard.score(idea.id) >= 5
      end

      grant_on 'ideas#publish', badge: 'entrepreneur', multiple: true, to: :student do |idea|
        Idea.leaderboard.score(idea.id) == 10000
      end

      grant_on 'ideas#publish', badge: 'validated', multiple: true, to: :itself do |idea|
        Idea.leaderboard.score(idea.id) == 10000
      end

      grant_on 'ideas#publish', badge: 'popular-idea', to: :itself do |idea|
        Idea.leaderboard.score(idea.id) == 5000
      end

      grant_on 'ideas#publish', badge: 'market-fit', to: :itself do |idea|
        Idea.leaderboard.score(idea.id) == 2500
      end

      grant_on 'ideas#publish', badge: 'viral', to: :itself do |idea|
        (DateTime.now - idea.created_at).to_i == 3 && Idea.leaderboard.score(idea.id) == 500
      end

      grant_on 'ideas#publish', badge: 'disrupt', to: :itself do |idea|
        (DateTime.now - idea.created_at).to_i == 5 && Idea.leaderboard.score(idea.id) == 1000
      end

      grant_on 'ideas#publish', badge: 'traction', to: :itself do |idea|
        (DateTime.now - idea.created_at).to_i == 10 && Idea.leaderboard.score(idea.id)/10 == 100
      end

      #Share related badges
      grant_on 'shares#create', badge: 'growth-hacking', multiple: true, to: :user do |share|
        (DateTime.now - share.created_at).to_i <= 3 && share.votes_counter.value * 5 == 50
      end

      #Feedback related badges

      grant_on 'feedbacks#create', badge: 'feedbacker', to: :user do |feedback|
        feedback.user.feedbacks_counter.value == 1 && Feedback.leaderboard.score(feedback.id) == 25
      end

      grant_on 'feedbacks#create', badge: 'early-adopter', multiple: true, to: :user do |feedback|
        feedback.idea.feedbacks_counter == 1
      end

      grant_on 'feedbacks#create', badge: 'mentor', to: :user do |feedback|
        feedback.user.helpful_feedbacks_counter == 10
      end

      grant_on 'feedbacks#create', badge: 'guru', to: :user do |feedback|
        feedback.user.helpful_feedbacks_counter == 100
      end

      grant_on 'feedbacks#create', badge: 'popular-feedback', to: :itself do |feedback|
        Feedback.leaderboard.score(feedback.id) == 500
      end

      #Investment related bages
      grant_on 'investments#create', badge: 'investor', to: :user do |investment|
        investment.user.investments_counter.value == 1
      end

      grant_on 'investments#create', badge: 'angel-investor', to: :user do |investment|
        investment.user.joined_within_a_year? && investment.user.angel_investor?
      end

      grant_on 'investments#create', badge: 'vc', to: :user do |investment|
        investment.user.joined_within_a_year? && investment.user.vc?
      end

      #Comments related badges

      grant_on 'comments#create', badge: 'commentator', to: :user do |comment|
        comment.user.comments_counter.value == 10
      end

      grant_on 'comments#create', badge: 'collaborative', to: :user do |comment|
        comment.user.comments_counter.value == 50 &&  comment.user.comments_score == 250
      end

      grant_on 'comments#create', badge: 'pundit', to: :user do |comment|
        comment.user.comments_counter.value == 100 &&  comment.user.comments_score == 1000
      end

      grant_on 'comments#create', badge: 'popular-comment', to: :itself do |comment|
        comment.votes_counter.value == 500
      end

      #Posts related badges
      grant_on 'posts#create', badge: 'influencer', to: :user do |post|
        post.user.posts_counter.value == 10 &&  Post.leaderboard.score(post.id) == 500
      end

      grant_on 'posts#create', badge: 'popular-post', to: :itself do |post|
        Post.leaderboard.score(post.id) == 500
      end

      #note related badges
      grant_on 'posts#create', badge: 'influencer', to: :user do |post|
        post.user.posts_counter.value == 10 && post.posts_score >= 50
      end

    end

  end
end
