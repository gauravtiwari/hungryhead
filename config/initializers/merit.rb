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
  name: "community",
  level: "bronze",
  description: "Joined the site",
  custom_fields: { name: "Community", points: 1 }
)

Merit::Badge.create!(
  id: 2,
  name: "autobiographer",
  level: "bronze",
  description: "Completed the about me section on profile page",
  custom_fields: { name: "Autobiographer", points: 2 }
)

Merit::Badge.create!(
  id: 3,
  name: "social",
  level: "bronze",
  description: "Connected with 200 people",
  custom_fields: { name: "Social", points: 10 }
)

Merit::Badge.create!(
  id: 4,
  name: "lean",
  level: "bronze",
  description: "Pitched first startup idea",
  custom_fields: { name: "Lean", points: 5 }
)

Merit::Badge.create!(
  id: 6,
  name: "feedbacker",
  level: "bronze",
  description: "Feedback with score of 25",
  custom_fields: { name: "Feedbacker", points: 5 }
)

Merit::Badge.create!(
  id: 7,
  name: "investor",
  level: "bronze",
  description: "First investment",
  custom_fields: { name: "Investor", points: 1 }
)

Merit::Badge.create!(
  id: 8,
  name: "angel-investor",
  level: "gold",
  description: "60 investments in a year of amount between 100 to 300",
  custom_fields: { name: "Angel Investor", points: 100  }
)

Merit::Badge.create!(
  id: 9,
  name: "vc",
  level: "gold",
  description: "150 investments in a year of amount between 500 to 900",
  custom_fields: { name: "VC", points: 200  }
)

Merit::Badge.create!(
  id: 10,
  name: "commentator",
  level: "silver",
  description: "Left 10 comments",
  custom_fields: { name: "Commentator", points: 5 }
)

Merit::Badge.create!(
  id: 11,
  name: "collaborative",
  level: "silver",
  description: "50 comments with cummulative score of 250",
  custom_fields: { name: "Collaborative", points: 25 }
)

Merit::Badge.create!(
  id: 12,
  name: "pundit",
  level: "gold",
  description: "100 comments with cummulative score of 1000",
  custom_fields: { name: "Pundit", points: 50 }
)

Merit::Badge.create!(
  id: 13,
  name: "enthusiast",
  level: "bronze",
  description: "Visited the site each day for 30 consecutive days.",
  custom_fields: { name: "Enthusiast", points: 15 }
)

Merit::Badge.create!(
  id: 14,
  name: "focussed",
  level: "silver",
  description: "Visited the site each day for 100 consecutive days.",
  custom_fields: { name: "Focussed", points: 50 }
)

Merit::Badge.create!(
  id: 15,
  name: "early-adopter",
  level: "bronze",
  description: "First feedback on a idea",
  custom_fields: { name: "Early Adopter", points: 2 }
)

Merit::Badge.create!(
  id: 16,
  name: "investable",
  level: "broze",
  description: "Idea Score 1000 or more",
  custom_fields: { name: "Investable", points: 2 }
)

Merit::Badge.create!(
  id: 17,
  name: "market-fit",
  level: "broze",
  description: "Idea with score of 500",
  custom_fields: { name: "Product Market Fit", points: 15 }
)

Merit::Badge.create!(
  id: 18,
  name: "viral",
  level: "silver",
  description: "Idea with score of 500 in 3 days",
  custom_fields: { name: "Viral", points: 50 }
)

Merit::Badge.create!(
  id: 19,
  name: "disruptive",
  level: "gold",
  description: "Idea with score of 1000 in 5 days",
  custom_fields: { name: "Disruptive", points: 100 }
)

Merit::Badge.create!(
  id: 20,
  name: "traction",
  level: "silver",
  description: "Idea with daily score of 100 for 10 days",
  custom_fields: { name: "Traction" }
)

Merit::Badge.create!(
  id: 21,
  name: "mentor",
  level: "silver",
  description: "10 helpful feedbacks",
  custom_fields: { name: "Mentor", points: 25 }
)

Merit::Badge.create!(
  id: 22,
  name: "guru",
  level: "gold",
  description: "100 helpful feedbacks",
  custom_fields: { name: "Guru", points: 100 }
)

Merit::Badge.create!(
  id: 23,
  name: "entrepreneur",
  level: "gold",
  description: "Successfully validated a startup idea",
  custom_fields: { name: "Entrepreneur", points: 500 }
)

Merit::Badge.create!(
  id: 24,
  name: "validated",
  level: "gold",
  description: "Validated startup idea",
  custom_fields: { name: "Validated", points: 500 }
)

#Feedback badges

Merit::Badge.create!(
  id: 25,
  name: "popular-feedback",
  level: "silver",
  description: "Feedback with score of 500 or more",
  custom_fields: { name: "Popular Feedback" }
)

Merit::Badge.create!(
  id: 27,
  name: "popular-comment",
  level: "silver",
  description: "Comment with score of 500 or more",
  custom_fields: { name: "Popular Comment" }
)

Merit::Badge.create!(
  id: 28,
  name: "popular-idea",
  level: "bronze",
  description: "Idea with a score of 5000",
  custom_fields: { name: "Popular Idea" }
)

