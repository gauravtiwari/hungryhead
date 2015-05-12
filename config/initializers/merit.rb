# Use this hook to configure merit parameters
Merit.setup do |config|
  # Check rules on each request or in background
  config.checks_on_each_request = false

  # Define ORM. Could be :active_record (default) and :mongoid
  # config.orm = :active_record

  # Add application observers to get notifications when reputation changes.
  # config.add_observer 'MyObserverClassName'

  #config.add_observer 'ReputationChangeObserver'

  # Define :user_model_name. This model will be used to grand badge if no
  # `:to` option is given. Default is 'User'.
  config.user_model_name = 'User'

  # Define :current_user_method. Similar to previous option. It will be used
  # to retrieve :user_model_name object if no `:to` option is given. Default
  # is "current_#{user_model_name.downcase}".
  config.current_user_method = 'current_user'
end


#User related
Merit::Badge.create!(
  id: 1,
  name: "just-registered",
  level: "beginner",
  type: "user",
  description: "Joined the community",
  custom_fields: { name: "Community",  points: 1, image: '/assets/badges/welcome.png', created_at: Time.now }
)

Merit::Badge.create!(
  id: 2,
  name: "entrepreneur",
  level: "beginner",
  type: "user",
  description: "Pitched first idea",
  custom_fields: { name: "Entrepreneur", points: 5,  image: '/assets/badges/idea-guy.png', created_at: Time.now  }
)

Merit::Badge.create!(
  id: 3,
  name: "feedbacker",
  level: "beginner",
  type: "user",
  description: "First feedback",
  custom_fields: { name: "Feedbacker", points: 1,  image: '/assets/badges/beginner.png', created_at: Time.now  }
)

Merit::Badge.create!(
  id: 4,
  name: "investor",
  type: "user",
  level: "beginner",
  description: "First investment",
  custom_fields: { name: "Investor", points: 1,  image: '/assets/badges/investor.png', created_at: Time.now  }
)

Merit::Badge.create!(
  id: 5,
  name: "commenter",
  type: "user",
  level: "medium",
  description: "First comment",
  custom_fields: { name: "Commenter", points: 15,  image: '/assets/badges/announcement.png', created_at: Time.now  }
)

Merit::Badge.create!(
  id: 6,
  name: "enthusiast",
  type: "user",
  level: "medium",
  description: "Visited the site each day for 30 consecutive days.",
  custom_fields: { name: "Enthusiast", points: 10,  image: '/assets/badges/feedbacks.png', created_at: Time.now  }
)

Merit::Badge.create!(
  id: 7,
  name: "commentator",
  type: "user",
  level: "expert",
  description: "Left 10 comments",
  custom_fields: { name: "10 Comments", points: 50,  image: '/assets/badges/top_comments.png', created_at: Time.now  }
)

Merit::Badge.create!(
  id: 8,
  name: "wise",
  type: "user",
  level: "medium",
  description: "10 accepted feedbacks",
  custom_fields: { name: "Wise", points: 10,  image: '/assets/badges/wise.png', created_at: Time.now  }
)


Merit::Badge.create!(
  id: 7,
  name: "focussed",
  type: "user",
  level: "expert",
  description: "Active everyday in last 30 days",
  custom_fields: { name: "Focussed", points: 30,  image: '/assets/badges/focussed.png', created_at: Time.now  }
)

Merit::Badge.create!(
  id: 8,
  name: "mentor",
  type: "user",
  level: "expert",
  description: "Verified Mentor",
  custom_fields: { name: "Mentor", points: 1,  image: '/assets/badges/mentor.png', created_at: Time.now  }
)

Merit::Badge.create!(
  id: 9,
  name: "teacher",
  type: "user",
  level: "expert",
  description: "Verified Faculty Member",
  custom_fields: { name: "Teacher", points: 1,  image: '/assets/badges/teacher.png', created_at: Time.now  }
)

Merit::Badge.create!(
  id: 10,
  name: "accepted",
  type: "feedback",
  level: "beginner",
  description: "Feedback Accepted",
  custom_fields: { name: "Accepted", bg: 'master', class: 'thumbs-up', points: 1, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 11,
  name: "rejected",
  type: "feedback",
  level: "beginner",
  description: "Feedback rejected",
  custom_fields: { name: "Rejected", bg: 'master', class: 'thumbs-down', points: 1, created_at: Time.now  }
)


Merit::Badge.create!(
  id: 11,
  name: "expert",
  type: "user",
  level: "expert",
  description: "10 game changing feedbacks",
  custom_fields: { name: "Expert", points: 50,  image: '/assets/badges/ninja.png', created_at: Time.now  }
)

Merit::Badge.create!(
  id: 12,
  name: "idea_award",
  type: "user",
  level: "expert",
  description: "Successfully validated a startup idea",
  custom_fields: { name: "Idea Award", points: 50,  image: '/assets/badges/cup.png', created_at: Time.now  }
)

Merit::Badge.create!(
  id: 13,
  name: "most_voted",
  type: "user",
  level: "expert",
  description: "50 votes",
  custom_fields: { name: "Received 50 votes", points: 50,  image: '/assets/badges/aplus.png', created_at: Time.now  }
)



#Badges for feedbacks
Merit::Badge.create!(
  id: 15,
  name: "helpful",
  type: "user",
  description: "Helful",
  custom_fields: { name: "helpful", bg: 'solid', class: 'thumbs-up', points: 1, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 16,
  name: "not-helpful",
  type: "user",
  description: "Not Helpful",
  custom_fields: { name: "Not Helpful", bg: 'master', class: 'thumbs-down', points: 0, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 17,
  name: "irrelevant",
  type: "user",
  description: "Irrelevant",
  custom_fields: { name: "Irrelevant", bg: 'complete', class: 'meh-o', points: -1, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 18,
  name: "very-helpful",
  type: "user",
  description: "Very Helpful",
  custom_fields: { name: "Very Helpful",  bg: 'danger', class: 'heart', points: 5, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 19,
  name: "game-changing",
  type: "user",
  description: "Game Changing",
  custom_fields: { name: "Game Changing",  bg: 'green', class: 'magic', points: 10, created_at: Time.now  }
)
