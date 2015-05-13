# Use this hook to configure merit parameters
Merit.setup do |config|
  # Check rules on each request or in background
  config.checks_on_each_request = false

  # Define ORM. Could be :active_record (default) and :mongoid
  # config.orm = :active_record

  # Add application observers to get notifications when reputation changes.
  # config.add_observer 'MyObserverClassName'

  config.add_observer 'ReputationChangeObserver'

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
  description: "Joined the community",
  custom_fields: { name: "Community",  points: 2 }
)

Merit::Badge.create!(
  id: 2,
  name: "autobiographer",
  level: "bronze",
  description: "Completed the about me section",
  custom_fields: { name: "Autobiographer",  points: 5 }
)

Merit::Badge.create!(
  id: 3,
  name: "top-10",
  level: "bronze",
  description: "First 10 to join the site",
  custom_fields: { name: "Top 10",  points: 5 }
)

Merit::Badge.create!(
  id: 4,
  name: "top-100",
  level: "bronze",
  description: "First 100 to join the site",
  custom_fields: { name: "Top 100",  points: 3 }
)

Merit::Badge.create!(
  id: 5,
  name: "top-1000",
  level: "bronze",
  description: "First 1000 to join the site",
  custom_fields: { name: "Top 1000",  points: 2 }
)

Merit::Badge.create!(
  id: 6,
  name: "top-10000",
  level: "bronze",
  description: "First 10000 to join the site",
  custom_fields: { name: "Top 10000",  points: 1 }
)

Merit::Badge.create!(
  id: 7,
  name: "beta",
  level: "bronze",
  description: "Joined private beta site and published an idea",
  custom_fields: { name: "Beta",  points: 5 }
)

Merit::Badge.create!(
  id: 8,
  name: "social",
  level: "bronze",
  description: "Followed 200 people",
  custom_fields: { name: "Social",  points: 5 }
)


Merit::Badge.create!(
  id: 9,
  name: "student",
  level: "bronze",
  description: "Pitched first idea",
  custom_fields: { name: "Student", points: 5  }
)

Merit::Badge.create!(
  id: 10,
  name: "lean",
  level: "bronze",
  description: "Pitched first idea with socre of 5",
  custom_fields: { name: "Lean", points: 5  }
)

Merit::Badge.create!(
  id: 11,
  name: "pivot",
  level: "bronze",
  description: "Changed the idea",
  custom_fields: { name: "Pivotted", points: 5  }
)

Merit::Badge.create!(
  id: 12,
  name: "growth-hacking",
  level: "bronze",
  description: "Shared idea and increased idea score by 50",
  custom_fields: { name: "Growth Hacking", points: 5  }
)

Merit::Badge.create!(
  id: 13,
  name: "feedbacker",
  level: "bronze",
  description: "First feedback with score of 5",
  custom_fields: { name: "Feedbacker", points: 1  }
)

Merit::Badge.create!(
  id: 14,
  name: "investor",
  level: "bronze",
  description: "First investment",
  custom_fields: { name: "Investor", points: 1  }
)


Merit::Badge.create!(
  id: 15,
  name: "enlightened",
  level: "silver",
  description: "First feedback with score of 25",
  custom_fields: { name: "Enlightened", points: 10  }
)

Merit::Badge.create!(
  id: 16,
  name: "angel-investor",
  level: "gold",
  description: "60 investments in a year",
  custom_fields: { name: "Angel Investor", points: 1  }
)

Merit::Badge.create!(
  id: 17,
  name: "VC",
  level: "gold",
  description: "150 investments in a year",
  custom_fields: { name: "VC", points: 15  }
)

Merit::Badge.create!(
  id: 18,
  name: "commentator",
  level: "silver",
  description: "Left 10 comments",
  custom_fields: { name: "Commentator", points: 5  }
)

Merit::Badge.create!(
  id: 19,
  name: "outspoken",
  level: "silver",
  description: "Left 25 comments",
  custom_fields: { name: "Outspoken", points: 10  }
)

Merit::Badge.create!(
  id: 20,
  name: "collaborative",
  level: "gold",
  description: "50 comments with score of 5",
  custom_fields: { name: "Collaborative", points: 15  }
)

Merit::Badge.create!(
  id: 21,
  name: "pundit",
  level: "gold",
  description: "100 comments with score of 10",
  custom_fields: { name: "Pundit", points: 25  }
)

Merit::Badge.create!(
  id: 22,
  name: "enthusiast",
  level: "bronze",
  description: "Visited the site each day for 30 consecutive days.",
  custom_fields: { name: "Enthusiast", points: 5  }
)

Merit::Badge.create!(
  id: 23,
  name: "early-adopter",
  level: "silver",
  description: "Voted first on 10 new ideas",
  custom_fields: { name: "Early Adopter", points: 5  }
)

Merit::Badge.create!(
  id: 24,
  name: "Influencer",
  level: "gold",
  description: "10 notes with score of 15",
  custom_fields: { name: "Influencer", points: 10  }
)


Merit::Badge.create!(
  id: 25,
  name: "market-fit",
  level: "silver",
  description: "Idea with score of 50",
  custom_fields: { name: "Product Market Fit", points: 25  }
)

Merit::Badge.create!(
  id: 26,
  name: "social-proof",
  level: "silver",
  description: "Idea with score of 100",
  custom_fields: { name: "Social Proof", points: 50  }
)

Merit::Badge.create!(
  id: 27,
  name: "viral",
  level: "gold",
  description: "Idea with score of 50 in 5 days",
  custom_fields: { name: "Viral", points: 50  }
)

Merit::Badge.create!(
  id: 28,
  name: "disrupt",
  level: "gold",
  description: "Idea with score of 100 in 5 days",
  custom_fields: { name: "Disruptive", points: 75  }
)

Merit::Badge.create!(
  id: 29,
  name: "traction",
  level: "gold",
  description: "Idea with daily score of 10 for 10 days",
  custom_fields: { name: "Traction", points: 50  }
)

Merit::Badge.create!(
  id: 30,
  name: "pundit",
  level: "gold",
  description: "Left 10 comments with score of 5",
  custom_fields: { name: "Pundit", points: 5  }
)

Merit::Badge.create!(
  id: 31,
  name: "wise",
  level: "gold",
  description: "10 helpful feedbacks",
  custom_fields: { name: "Wise", points: 5  }
)

Merit::Badge.create!(
  id: 32,
  name: "focussed",
  level: "gold",
  description: "Visited the site each day for 100 consecutive days.",
  custom_fields: { name: "Focussed", points: 25  }
)

Merit::Badge.create!(
  id: 33,
  name: "mentor",
  level: "expert",
  description: "Feedbacked 10 ideas",
  custom_fields: { name: "Mentor", points: 1  }
)

Merit::Badge.create!(
  id: 34,
  name: "teacher",
  level: "expert",
  description: "Feedback with a score of 10",
  custom_fields: { name: "Teacher", points: 1  }
)

Merit::Badge.create!(
  id: 35,
  name: "guru",
  level: "guru",
  description: "Accepted feedback with score of 40 or more",
  custom_fields: { name: "Guru", points: 50  }
)

Merit::Badge.create!(
  id: 36,
  name: "entrepreneur",
  level: "gold",
  description: "Successfully validated a startup idea",
  custom_fields: { name: "Entrepreneur", points: 25  }
)

Merit::Badge.create!(
  id: 37,
  name: "good-feedback",
  level: "gold",
  description: "Feedback score of 25 or more",
  custom_fields: { name: "Good Feedback", points: 5  }
)

Merit::Badge.create!(
  id: 38,
  name: "great-feedback",
  level: "gold",
  description: "Feedback score of 100 or more",
  custom_fields: { name: "Great Feedback", points: 25  }
)


Merit::Badge.create!(
  id: 39,
  name: "popular-idea",
  level: "gold",
  description: "Idea with a score of 25 or more",
  custom_fields: { name: "Popular Idea", points: 5  }
)

Merit::Badge.create!(
  id: 40,
  name: "famous-idea",
  level: "gold",
  description: "Idea with a score of 100 or more",
  custom_fields: { name: "Famous Idea", points: 25  }
)
