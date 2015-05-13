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
  level: "bronze",
  type: "user",
  description: "Joined the community",
  custom_fields: { name: "Community",  points: 2, created_at: Time.now }
)

Merit::Badge.create!(
  id: 2,
  name: "autobiographer",
  level: "bronze",
  type: "user",
  description: "Completed the about me section",
  custom_fields: { name: "Autobiographer",  points: 5, created_at: Time.now }
)

Merit::Badge.create!(
  id: 3,
  name: "top-10",
  level: "bronze",
  type: "user",
  description: "First 10 to join the site",
  custom_fields: { name: "Top 10",  points: 5, created_at: Time.now }
)

Merit::Badge.create!(
  id: 4,
  name: "top-100",
  level: "bronze",
  type: "user",
  description: "First 100 to join the site",
  custom_fields: { name: "Top 100",  points: 3, created_at: Time.now }
)

Merit::Badge.create!(
  id: 4,
  name: "top-1000",
  level: "bronze",
  type: "user",
  description: "First 1000 to join the site",
  custom_fields: { name: "Top 1000",  points: 2, created_at: Time.now }
)

Merit::Badge.create!(
  id: 4,
  name: "top-10000",
  level: "bronze",
  type: "user",
  description: "First 10000 to join the site",
  custom_fields: { name: "Top 10000",  points: 1, created_at: Time.now }
)

Merit::Badge.create!(
  id: 4,
  name: "beta",
  level: "bronze",
  type: "user",
  description: "Joined private beta site and published an idea",
  custom_fields: { name: "Beta",  points: 5, created_at: Time.now }
)

Merit::Badge.create!(
  id: 4,
  name: "social",
  level: "bronze",
  type: "user",
  description: "Followed 200 people",
  custom_fields: { name: "Social",  points: 5, created_at: Time.now }
)


Merit::Badge.create!(
  id: 7,
  name: "student",
  level: "bronze",
  type: "user",
  description: "Pitched first idea",
  custom_fields: { name: "Student", points: 5, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 7,
  name: "lean",
  level: "bronze",
  type: "user",
  description: "Pitched first idea with socre of 5",
  custom_fields: { name: "Lean", points: 5, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 7,
  name: "pivot",
  level: "bronze",
  type: "user",
  description: "Changed the idea",
  custom_fields: { name: "Pivotted", points: 5, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 7,
  name: "growth-hacking",
  level: "bronze",
  type: "user",
  description: "Shared idea and increased idea score by 50",
  custom_fields: { name: "Growth Hacking", points: 5, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 8,
  name: "feedbacker",
  level: "bronze",
  type: "user",
  description: "First feedback with score of 5",
  custom_fields: { name: "Feedbacker", points: 1, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 4,
  name: "investor",
  type: "user",
  level: "bronze",
  description: "First investment",
  custom_fields: { name: "Investor", points: 1, created_at: Time.now  }
)


Merit::Badge.create!(
  id: 9,
  name: "enlightened",
  level: "silver",
  type: "user",
  description: "First feedback with score of 25",
  custom_fields: { name: "Enlightened", points: 10, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 4,
  name: "angel-investor",
  type: "user",
  level: "gold",
  description: "60 investments in a year",
  custom_fields: { name: "Angel Investor", points: 1, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 4,
  name: "VC",
  type: "user",
  level: "gold",
  description: "150 investments in a year",
  custom_fields: { name: "VC", points: 15, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 7,
  name: "commentator",
  type: "user",
  level: "silver",
  description: "Left 10 comments",
  custom_fields: { name: "Commentator", points: 5, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 5,
  name: "outspoken",
  type: "user",
  level: "silver",
  description: "Left 25 comments",
  custom_fields: { name: "Outspoken", points: 10, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 5,
  name: "collaborative",
  type: "gold",
  level: "medium",
  description: "50 comments with score of 5",
  custom_fields: { name: "Collaborative", points: 15, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 5,
  name: "pundit",
  type: "user",
  level: "gold",
  description: "100 comments with score of 10",
  custom_fields: { name: "Pundit", points: 25, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 6,
  name: "enthusiast",
  type: "user",
  level: "bronze",
  description: "Visited the site each day for 30 consecutive days.",
  custom_fields: { name: "Enthusiast", points: 5, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 6,
  name: "early-adopter",
  type: "user",
  level: "silver",
  description: "Voted first on 10 new ideas",
  custom_fields: { name: "Early Adopter", points: 5, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 6,
  name: "Influencer",
  type: "user",
  level: "gold",
  description: "10 notes with score of 15",
  custom_fields: { name: "Influencer", points: 10, created_at: Time.now  }
)


Merit::Badge.create!(
  id: 6,
  name: "market-fit",
  type: "user",
  level: "silver",
  description: "Idea with score of 50",
  custom_fields: { name: "Product Market Fit", points: 25, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 6,
  name: "social-proof",
  type: "user",
  level: "silver",
  description: "Idea with score of 100",
  custom_fields: { name: "Social Proof", points: 50, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 6,
  name: "viral",
  type: "user",
  level: "gold",
  description: "Idea with score of 50 in 5 days",
  custom_fields: { name: "Viral", points: 50, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 6,
  name: "disrupt",
  type: "user",
  level: "gold",
  description: "Idea with score of 100 in 5 days",
  custom_fields: { name: "Disruptive", points: 75, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 6,
  name: "traction",
  type: "user",
  level: "gold",
  description: "Idea with daily score of 10 for 10 days",
  custom_fields: { name: "Traction", points: 50, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 7,
  name: "pundit",
  type: "user",
  level: "gold",
  description: "Left 10 comments with score of 5",
  custom_fields: { name: "Pundit", points: 5, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 8,
  name: "wise",
  type: "user",
  level: "gold",
  description: "10 helpful feedbacks",
  custom_fields: { name: "Wise", points: 5, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 9,
  name: "focussed",
  type: "user",
  level: "gold",
  description: "Visited the site each day for 100 consecutive days.",
  custom_fields: { name: "Focussed", points: 25, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 10,
  name: "mentor",
  type: "user",
  level: "expert",
  description: "Feedbacked 10 ideas",
  custom_fields: { name: "Mentor", points: 1, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 11,
  name: "teacher",
  type: "user",
  level: "expert",
  description: "Feedback with a score of 10",
  custom_fields: { name: "Teacher", points: 1, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 12,
  name: "guru",
  type: "user",
  level: "guru",
  description: "Accepted feedback with score of 40 or more",
  custom_fields: { name: "Guru", points: 50, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 13,
  name: "entrepreneur",
  type: "user",
  level: "gold",
  description: "Successfully validated a startup idea",
  custom_fields: { name: "Entrepreneur", points: 25, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 25,
  name: "good-feedback",
  type: "user",
  level: "gold",
  description: "Feedback score of 25 or more",
  custom_fields: { name: "Good Feedback", points: 5, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 25,
  name: "great-feedback",
  type: "user",
  level: "gold",
  description: "Feedback score of 100 or more",
  custom_fields: { name: "Great Feedback", points: 25, created_at: Time.now  }
)


Merit::Badge.create!(
  id: 25,
  name: "popular-idea",
  type: "user",
  level: "gold",
  description: "Idea with a score of 25 or more",
  custom_fields: { name: "Popular Idea", points: 5, created_at: Time.now  }
)

Merit::Badge.create!(
  id: 25,
  name: "famous-idea",
  type: "user",
  level: "gold",
  description: "Idea with a score of 100 or more",
  custom_fields: { name: "Famous Idea", points: 25, created_at: Time.now  }
)
