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
  description: "Joined the community",
  custom_fields: { name: "Community" }
)

Merit::Badge.create!(
  id: 2,
  name: "autobiographer",
  level: "bronze",
  description: "Completed the about me section",
  custom_fields: { name: "Autobiographer" }
)

Merit::Badge.create!(
  id: 3,
  name: "top-10",
  level: "bronze",
  description: "First 10 to join the site",
  custom_fields: { name: "Top 10"}
)

Merit::Badge.create!(
  id: 4,
  name: "top-100",
  level: "bronze",
  description: "First 100 to join the site",
  custom_fields: { name: "Top 100"}
)

Merit::Badge.create!(
  id: 5,
  name: "top-1000",
  level: "bronze",
  description: "First 1000 to join the site",
  custom_fields: { name: "Top 1000"}
)

Merit::Badge.create!(
  id: 6,
  name: "top-10000",
  level: "bronze",
  description: "First 10000 to join the site",
  custom_fields: { name: "Top 10000" }
)

Merit::Badge.create!(
  id: 7,
  name: "beta",
  level: "bronze",
  description: "Joined private beta site and published an idea",
  custom_fields: { name: "Beta"}
)

Merit::Badge.create!(
  id: 8,
  name: "social",
  level: "bronze",
  description: "Followed 200 people",
  custom_fields: { name: "Social"}
)


Merit::Badge.create!(
  id: 9,
  name: "student",
  level: "bronze",
  description: "Pitched first idea",
  custom_fields: { name: "Student"}
)

Merit::Badge.create!(
  id: 10,
  name: "lean",
  level: "bronze",
  description: "Pitched first idea with score of 5",
  custom_fields: { name: "Lean"}
)

Merit::Badge.create!(
  id: 11,
  name: "pivot",
  level: "bronze",
  description: "Changed the idea",
  custom_fields: { name: "Pivotted" }
)

Merit::Badge.create!(
  id: 12,
  name: "growth-hacking",
  level: "bronze",
  description: "Shared idea and increased idea score by 50",
  custom_fields: { name: "Growth Hacking" }
)

Merit::Badge.create!(
  id: 13,
  name: "feedbacker",
  level: "bronze",
  description: "First feedback with score of 5",
  custom_fields: { name: "Feedbacker" }
)

Merit::Badge.create!(
  id: 14,
  name: "investor",
  level: "bronze",
  description: "First investment",
  custom_fields: { name: "Investor" }
)

Merit::Badge.create!(
  id: 16,
  name: "angel-investor",
  level: "gold",
  description: "60 investments in a year",
  custom_fields: { name: "Angel Investor" }
)

Merit::Badge.create!(
  id: 17,
  name: "VC",
  level: "gold",
  description: "150 investments in a year",
  custom_fields: { name: "VC" }
)

Merit::Badge.create!(
  id: 18,
  name: "commentator",
  level: "silver",
  description: "Left 10 comments",
  custom_fields: { name: "Commentator" }
)

Merit::Badge.create!(
  id: 19,
  name: "outspoken",
  level: "silver",
  description: "Left 25 comments",
  custom_fields: { name: "Outspoken" }
)

Merit::Badge.create!(
  id: 20,
  name: "collaborative",
  level: "gold",
  description: "50 comments with score of 5",
  custom_fields: { name: "Collaborative" }
)

Merit::Badge.create!(
  id: 21,
  name: "pundit",
  level: "gold",
  description: "100 comments with score of 10",
  custom_fields: { name: "Pundit" }
)

Merit::Badge.create!(
  id: 22,
  name: "enthusiast",
  level: "bronze",
  description: "Visited the site each day for 30 consecutive days.",
  custom_fields: { name: "Enthusiast" }
)

Merit::Badge.create!(
  id: 23,
  name: "early-adopter",
  level: "silver",
  description: "Voted first on 10 new ideas",
  custom_fields: { name: "Early Adopter" }
)

Merit::Badge.create!(
  id: 24,
  name: "influencer",
  level: "gold",
  description: "10 notes with score of 15",
  custom_fields: { name: "Influencer" }
)


Merit::Badge.create!(
  id: 25,
  name: "market-fit",
  level: "silver",
  description: "Idea with score of 50",
  custom_fields: { name: "Product Market Fit" }
)

Merit::Badge.create!(
  id: 26,
  name: "social-proof",
  level: "silver",
  description: "Idea with score of 100",
  custom_fields: { name: "Social Proof" }
)

Merit::Badge.create!(
  id: 27,
  name: "viral",
  level: "gold",
  description: "Idea with score of 50 in 5 days",
  custom_fields: { name: "Viral" }
)

Merit::Badge.create!(
  id: 28,
  name: "disrupt",
  level: "gold",
  description: "Idea with score of 100 in 5 days",
  custom_fields: { name: "Disruptive" }
)

Merit::Badge.create!(
  id: 29,
  name: "traction",
  level: "gold",
  description: "Idea with daily score of 10 for 10 days",
  custom_fields: { name: "Traction" }
)

Merit::Badge.create!(
  id: 30,
  name: "pundit",
  level: "gold",
  description: "Left 10 comments with score of 5",
  custom_fields: { name: "Pundit" }
)

Merit::Badge.create!(
  id: 31,
  name: "wise",
  level: "gold",
  description: "10 helpful feedbacks",
  custom_fields: { name: "Wise" }
)

Merit::Badge.create!(
  id: 32,
  name: "focussed",
  level: "gold",
  description: "Visited the site each day for 100 consecutive days.",
  custom_fields: { name: "Focussed" }
)

Merit::Badge.create!(
  id: 33,
  name: "mentor",
  level: "expert",
  description: "Feedbacked 10 ideas",
  custom_fields: { name: "Mentor" }
)

Merit::Badge.create!(
  id: 34,
  name: "teacher",
  level: "expert",
  description: "Feedback with a score of 10",
  custom_fields: { name: "Teacher" }
)

Merit::Badge.create!(
  id: 35,
  name: "guru",
  level: "guru",
  description: "Accepted feedback with score of 40 or more",
  custom_fields: { name: "Guru" }
)

Merit::Badge.create!(
  id: 36,
  name: "entrepreneur",
  level: "gold",
  description: "Successfully validated a startup idea",
  custom_fields: { name: "Entrepreneur" }
)

Merit::Badge.create!(
  id: 37,
  name: "good-feedback",
  level: "gold",
  description: "Feedback score of 25 or more",
  custom_fields: { name: "Good Feedback" }
)

Merit::Badge.create!(
  id: 38,
  name: "great-feedback",
  level: "gold",
  description: "Feedback score of 100 or more",
  custom_fields: { name: "Great Feedback" }
)


Merit::Badge.create!(
  id: 39,
  name: "popular-idea",
  level: "gold",
  description: "Idea with a score of 25 or more",
  custom_fields: { name: "Popular Idea" }
)

Merit::Badge.create!(
  id: 40,
  name: "famous-idea",
  level: "gold",
  description: "Idea with a score of 100 or more",
  custom_fields: { name: "Famous Idea" }
)
