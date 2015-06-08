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

      ###########################
      # => User related badges
      ###########################

      grant_on 'welcome#show', badge: 'community', :model_name => 'User' do |user|
        user.rules_accepted?
      end

      grant_on 'users#update', badge: 'autobiographer', to: :itself, temporary: true do |user|
        user.about_me.present?
      end

      grant_on 'sessions#create', badge: 'enthusiast', :model_name => 'User' do |user|
        user.sign_in_count >= 30
      end

      grant_on 'sessions#create', badge: 'focussed', :model_name => 'User' do |user|
        user.sign_in_count >= 100
      end

      grant_on 'follows#create', badge: 'social', to: :follower do |follow|
        follow.follower.friends_count >= 200
      end

      ##############################
        # => Idea related badges
      ##############################

      #########################################################
      # => Check everytime idea is viewed/voted/commented to grant lean badge
      #########################################################

      grant_on 'ideas#show', badge: 'lean', to: :student do |idea|
        idea.published? &&
        idea.student.ideas_counter.value >= 1 &&
        Idea.leaderboard.score(idea.id) >= 5
      end

      #Check everytime comment is created //hack
      grant_on 'comments#create', badge: 'lean', to: :commentable_user do |comment|
        comment.commentable_type == "Idea" &&
        comment.commentable.published? &&
        comment.commentable_user.ideas_counter.value >= 1 &&
        Idea.leaderboard.score(comment.commentable_id) >= 5
      end

      #Check everytime vote is casted //hack
      grant_on 'votes#vote', badge: 'lean', to: :votable_user do |vote|
        vote.votable_type == "Idea" &&
        vote.votable.published? &&
        vote.votable_user.ideas_counter.value >= 1 &&
        Idea.leaderboard.score(vote.votable_id) >= 5
      end

      ################################################################
      # => Check everytime idea is viewed/voted/commented to grant entrepreneur badge
      ################################################################

      grant_on 'ideas#show', badge: 'entrepreneur', to: :student do |idea|
        idea.published? &&
        Idea.leaderboard.score(idea.id) >= 10000
      end

      #Check everytime comment is created //hack
      grant_on 'comments#create', badge: 'entrepreneur', to: :commentable_user do |comment|
        comment.commentable_type == "Idea" &&
        comment.commentable.published? &&
        Idea.leaderboard.score(comment.commentable_id) >= 10000
      end

      #Check everytime vote is casted //hack
      grant_on 'votes#vote', badge: 'entrepreneur', to: :votable_user do |vote|
        vote.votable_type == "Idea" &&
        vote.votable.published? &&
        Idea.leaderboard.score(vote.votable_id) >= 10000
      end

      ##################################################################
      # Check everytime idea is viewed/voted/commented to grant validated badge to IDEA
      # ################################################################

      grant_on 'ideas#show', badge: 'validated', to: :itself do |idea|
        idea.published? &&
        Idea.leaderboard.score(idea.id) >= 10000
      end

      #Check everytime comment is created //hack
      grant_on 'comments#create', badge: 'validated', to: :commentable do |comment|
        comment.commentable_type == "Idea" &&
        comment.commentable.published? &&
        Idea.leaderboard.score(comment.commentable_id) >= 10000
      end

      #Check everytime vote is casted //hack
      grant_on 'votes#vote', badge: 'validated', to: :votable do |vote|
        vote.votable_type == "Idea" &&
        vote.votable.published? &&
        Idea.leaderboard.score(vote.votable_id) >= 10000
      end


      ##################################################################
      # Check everytime idea is viewed to grant popular-idea badge to IDEA
      # ################################################################

      grant_on 'ideas#show', badge: 'popular-idea', to: :itself do |idea|
        idea.published? &&
        Idea.trending.score(idea.id) >= 200
      end


      ##################################################################
      # => Check everytime idea is viewed to grant market-fit badge to IDEA
      # ################################################################

      grant_on 'ideas#show', badge: 'market-fit', to: :itself do |idea|
        idea.published? &&
        Idea.leaderboard.score(idea.id) >= 2500
      end

      #Check everytime comment is created //hack
      grant_on 'comments#create', badge: 'market-fit', to: :commentable do |comment|
        comment.commentable_type == "Idea" &&
        comment.commentable.published? &&
        Idea.leaderboard.score(comment.commentable_id) >= 2500
      end

      #Check everytime vote is casted //hack
      grant_on 'votes#vote', badge: 'market-fit', to: :votable do |vote|
        vote.votable_type == "Idea" &&
        vote.votable.published? &&
        Idea.leaderboard.score(vote.votable_id) >= 2500
      end


      ##################################################################
      # => Check everytime idea is viewed to grant viral badge to IDEA
      # ################################################################

      grant_on 'ideas#show', badge: 'viral', to: :itself do |idea|
        days = (DateTime.now.to_date - idea.created_at.to_date).to_i
        idea.published? &&
        days.between?(1, 3) &&
        Idea.trending.score(idea.id) >= 500
      end

      ##################################################################
      # => Check everytime idea is viewed to grant disrupt badge to IDEA
      # ################################################################
      grant_on 'ideas#show', badge: 'disrupt', to: :itself do |idea|
        days = (DateTime.now.to_date - idea.created_at.to_date).to_i
        idea.published? &&
        days.between?(1, 5) &&
        Idea.trending.score(idea.id) >= 1000
      end

      ##################################################################
      # => Check everytime idea is viewed to grant traction badge to IDEA
      # ################################################################

      grant_on 'ideas#show', badge: 'traction', to: :itself do |idea|
        days = (DateTime.now.to_date - idea.created_at.to_date).to_i
        idea.published? &&
        days.between?(5, 10) &&
        Idea.leaderboard.score(idea.id)/days >= 100
      end

      ##############################
        # => Feedback related badges
      ##############################

      # 1. Feedbacker
      grant_on 'comments#create', badge: 'feedbacker', to: :commentable_user do |comment|
        comment.commentable_type == "Feedback" &&
        Feedback.leaderboard.score(comment.commentable_id) >= 25
      end

      grant_on 'votes#create', badge: 'feedbacker', to: :votable_user do |vote|
        vote.votable_type == "Feedback" &&
        Feedback.leaderboard.score(vote.votable_id) >= 25
      end


      #2. Early adopter
      grant_on 'feedbacks#create', badge: 'early-adopter', multiple: true, to: :user do |feedback|
        feedback.user.feedbacks_counter.value >= 10 && feedback.idea.feedbackers_counter.value == 1
      end

      # 3. Mentor
      grant_on 'feedbacks#create', badge: 'mentor', to: :user do |feedback|
        feedback.user.helpful_feedbacks_counter >= 10
      end

      # 4. Guru
      grant_on 'feedbacks#create', badge: 'guru', to: :user do |feedback|
        feedback.user.helpful_feedbacks_counter >= 100
      end

      # 5. Popular Feedback
      #Based on comment //hack
      grant_on 'comments#create', badge: 'popular-feedback', to: :commentable do |comment|
        comment.commentable_type == "Feedback" &&
        Feedback.leaderboard.score(comment.commentable_id) >= 500
      end

      #Based on vote //hack
      grant_on 'votes#vote', badge: 'popular-feedback', to: :votable do |vote|
        vote.votable_type == "Feedback" &&
        Feedback.leaderboard.score(vote.votable_id) >= 500
      end

      ##############################
        # => Investment related bages
      # #############################

      grant_on 'investments#create', badge: 'investor', to: :user do |investment|
        investment.user.investments_counter.value >= 5
      end

      grant_on 'investments#create', badge: 'angel-investor', to: :user do |investment|
        investment.user.joined_within_a_year? &&
        investment.user.angel_investor?
      end

      grant_on 'investments#create', badge: 'vc', to: :user do |investment|
        investment.user.joined_within_a_year? &&
        investment.user.vc?
      end

      #############################
        # => Comments related badges
      # ############################

      grant_on 'comments#create', badge: 'commentator', to: :user do |comment|
        comment.user.comments_counter.value >= 10
      end

      grant_on 'votes#vote', badge: 'popular-comment', to: :votable do |vote|
        vote.votable_type == "Comment" &&
        vote.votable.votes_counter.value >= 500
      end

      grant_on 'votes#vote', badge: 'collaborative', to: :votable_user do |vote|
        vote.votable_type == "Comment" &&
        vote.votable_user.comments_counter.value >= 50 &&
        vote.votable_user.comments_score >= 250
      end

      grant_on 'votes#vote', badge: 'pundit', to: :votable_user do |vote|
        vote.votable_type == "Comment" &&
        vote.votable_user.comments_counter.value >= 100 &&
        vote.votable_user.comments_score >= 1000
      end


    end

  end
end
