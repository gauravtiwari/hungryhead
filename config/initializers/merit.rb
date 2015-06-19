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
  description: "Joined the website",
  custom_fields: { name: "Community", type: "user" }
)

Merit::Badge.create!(
  id: 2,
  name: "autobiographer",
  level: "bronze",
  description: "Completed the about me section on profile page",
  custom_fields: { name: "Autobiographer", type: "user" }
)

Merit::Badge.create!(
  id: 3,
  name: "social",
  level: "bronze",
  description: "Followed/Connected with 200 people",
  custom_fields: { name: "Social", type: "user" }
)

Merit::Badge.create!(
  id: 4,
  name: "lean",
  level: "bronze",
  description: "Pitched first startup idea with score of 5",
  custom_fields: { name: "Lean", type: "user" }
)

Merit::Badge.create!(
  id: 5,
  name: "feedbacker",
  level: "bronze",
  description: "Feedback with score of 25",
  custom_fields: { name: "Feedbacker", type: "user" }
)

Merit::Badge.create!(
  id: 6,
  name: "investor",
  level: "bronze",
  description: "5 startup idea investments",
  custom_fields: { name: "Investor", type: "user" }
)

Merit::Badge.create!(
  id: 7,
  name: "angel-investor",
  level: "silver",
  description: "60 investments in a year of amount between 100 to 300",
  custom_fields: { name: "Angel Investor", type: "user"  }
)

Merit::Badge.create!(
  id: 8,
  name: "vc",
  level: "gold",
  description: "150 investments in a year of amount between 500 to 900",
  custom_fields: { name: "VC", type: "user"  }
)

Merit::Badge.create!(
  id: 9,
  name: "commentator",
  level: "bronze",
  description: "Posted 10 comments",
  custom_fields: { name: "Commentator", type: "user" }
)

Merit::Badge.create!(
  id: 10,
  name: "collaborative",
  level: "silver",
  description: "Posted 50 or more comments with a total score of 500",
  custom_fields: { name: "Collaborative", type: "user" }
)

Merit::Badge.create!(
  id: 11,
  name: "enthusiast",
  level: "bronze",
  description: "Visited the site each day for 30 consecutive days.",
  custom_fields: { name: "Enthusiast", type: "user" }
)

Merit::Badge.create!(
  id: 12,
  name: "focussed",
  level: "silver",
  description: "Visited the site each day for 100 consecutive days.",
  custom_fields: { name: "Focussed", points: 50, type: "user" }
)

Merit::Badge.create!(
  id: 13,
  name: "early-adopter",
  level: "bronze",
  description: "Feedbacked 5 startup ideas",
  custom_fields: { name: "Early Adopter", type: "user" }
)

Merit::Badge.create!(
  id: 14,
  name: "investable",
  level: "bronze",
  description: "Idea Score of 1000 or more",
  custom_fields: { name: "Investable", type: "idea" }
)

Merit::Badge.create!(
  id: 15,
  name: "market-fit",
  level: "bronze",
  description: "Idea Score of 500 or more",
  custom_fields: { name: "Product Market Fit", type: "idea" }
)

Merit::Badge.create!(
  id: 16,
  name: "viral",
  level: "silver",
  description: "Idea score of 500 in 3 days",
  custom_fields: { name: "Viral", type: "idea" }
)

Merit::Badge.create!(
  id: 17,
  name: "disruptive",
  level: "gold",
  description: "Idea score of 1000 in 5 days",
  custom_fields: { name: "Disruptive", type: "idea" }
)

Merit::Badge.create!(
  id: 18,
  name: "traction",
  level: "silver",
  description: "Idea with daily score of 100 or more for 10 days",
  custom_fields: { name: "Traction", type: "idea" }
)

Merit::Badge.create!(
  id: 19,
  name: "mentor",
  level: "silver",
  description: "Gave 10 helpful feedbacks",
  custom_fields: { name: "Mentor", type: "user" }
)

Merit::Badge.create!(
  id: 20,
  name: "guru",
  level: "gold",
  description: "Gave 100 helpful feedbacks",
  custom_fields: { name: "Guru", type: "user" }
)

Merit::Badge.create!(
  id: 21,
  name: "entrepreneur",
  level: "gold",
  description: "Successfully validated a startup idea (Idea Score: 10K)",
  custom_fields: { name: "Entrepreneur", type: "user" }
)

Merit::Badge.create!(
  id: 22,
  name: "validated",
  level: "gold",
  description: "Validated startup idea (Idea Score: 10K)",
  custom_fields: { name: "Validated", type: "idea" }
)

#Feedback badges
Merit::Badge.create!(
  id: 23,
  name: "pundit",
  level: "silver",
  description: "Feedback with score of 500 or more",
  custom_fields: { name: "Pundit", type: "feedback" }
)

Merit::Badge.create!(
  id: 24,
  name: "popular-idea",
  level: "bronze",
  description: "Idea with 500 unique views within 10 days",
  custom_fields: { name: "Popular Idea", type: "idea" }
)

Merit::Badge.create!(
  id: 25,
  name: "Exit",
  level: "gold",
  description: "Successful Exit: Invested in a validated idea and made return on investment",
  custom_fields: { name: "Exit", type: "user" }
)

