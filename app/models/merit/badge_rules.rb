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
      grant_on 'welcome#update', badge: 'just-registered', :model_name => 'User' do |user|
        user.rules_accepted?
      end

      grant_on 'sessions#create', badge: 'enthusiast', :model_name => 'User' do |user|
        (user.updated_at - user.created_at).to_i == 30
      end

      grant_on 'users#update', badge: 'fish', to: :itself do |user|
        user.rejected_feedbacks_counter == 10
      end

      grant_on 'users#update', badge: 'orphaned', to: :user do |feedback|
        feedback.user.orphaned_feedbacks_counter == 10
      end

      #Idea related badges
      grant_on 'ideas#publish', badge: 'entrepreneur', to: :student do |idea|
        idea.student.ideas_counter == 1
      end

      #Feedback related badges
      grant_on 'feedbacks#create', badge: 'feedbacker', to: :user do |feedback|
        feedback.user.feedbacks_counter == 1
      end

      grant_on 'feedbacks#rate', badge: 'wise', to: :user do |feedback|
        feedback.user.accepted_feedbacks_counter == 10
      end

      grant_on 'feedbacks#accept', badge: 'accepted', to: :itself do |feedback|
        feedback.accepted?
      end

      grant_on 'feedbacks#reject', badge: 'rejected', to: :itself do |feedback|
        feedback.rejected?
      end

      #Investment related bages
      grant_on 'investments#create', badge: 'investor', to: :user do |investment|
        investment.user.investments_counter == 1
      end

      #Comments related badges
      grant_on 'comments#create', badge: 'commenter', to: :user do |comment|
        comment.user.comments_counter == 1
      end

      grant_on 'comments#create', badge: 'commentator', to: :user do |comment|
        comment.user.comments_counter == 10
      end


      # If it creates user, grant badge
      # Should be "current_user" after registration for badge to be granted.
      # grant_on 'users#create', badge: 'just-registered', to: :itself

      # If it has 10 comments, grant commenter-10 badge
      # grant_on 'comments#create', badge: 'commenter', level: 10 do |comment|
      #   comment.user.comments.count == 10
      # end

      # If it has 5 votes, grant relevant-commenter badge
      # grant_on 'comments#vote', badge: 'relevant-commenter',
      #   to: :user do |comment|
      #
      #   comment.votes.count == 5
      # end

      # Changes his name by one wider than 4 chars (arbitrary ruby code case)
      # grant_on 'registrations#update', badge: 'autobiographer',
      #   temporary: true, model_name: 'User' do |user|
      #
      #   user.name.length > 4
      # end
    end
  end
end
