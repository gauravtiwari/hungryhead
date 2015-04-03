# Use this hook to configure merit parameters
Merit.setup do |config|
  # Check rules on each request or in background
  # config.checks_on_each_request = true

  # Define ORM. Could be :active_record (default) and :mongoid
  # config.orm = :active_record

  # Add application observers to get notifications when reputation changes.
  # config.add_observer 'MyObserverClassName'

  #config.add_observer 'ReputationChangeObserver'

  # Define :user_model_name. This model will be used to grand badge if no
  # `:to` option is given. Default is 'User'.
  # config.user_model_name = 'User'

  # Define :current_user_method. Similar to previous option. It will be used
  # to retrieve :user_model_name object if no `:to` option is given. Default
  # is "current_#{user_model_name.downcase}".
   config.current_user_method = 'current_user'
end

# Create application badges (uses https://github.com/norman/ambry)
# badge_id = 0
# [{
#   id: (badge_id = badge_id+1),
#   name: 'just-registered'
# }, {
#   id: (badge_id = badge_id+1),
#   name: 'best-unicorn',
#   custom_fields: { category: 'fantasy' }
# }].each do |attrs|
#   Merit::Badge.create! attrs
# end

Merit::Badge.create!(
  id: 1,
  name: "just-registered",
  level: "beginner",
  description: "Joined HungyHead",
  custom_fields: { name: "Community",  points: 1, image: '/assets/badges/welcome.png', created_at: Time.now }
)

Merit::Badge.create!(
  id: 2,
  name: "entrepreneur",
  type: "idea",
  description: "Published a idea",
  custom_fields: { name: "Entrepreneur", points: 10,  image: '/assets/badges/idea-guy.png', created_at: Time.now  }
)

Merit::Badge.create!(
  id: 3,
  name: "starter",
  type: "idea",
  description: "Made first feedback or investment",
  custom_fields: { name: "Starter", points: 1,  image: '/assets/badges/feedbacks.png', created_at: Time.now  }
)
Merit::Badge.create!(
  id: 4,
  name: "enthusiast",
  type: "idea",
  description: "10 feedback",
  custom_fields: { name: "Enthusiast", points: 10,  image: '/assets/badges/beginner.png', created_at: Time.now  }
)
Merit::Badge.create!(
  id: 5,
  name: "focussed",
  type: "user",
  description: "Active everyday",
  custom_fields: { name: "Focussed", points: 10,  image: '/assets/badges/focussed.png', created_at: Time.now  }
)

Merit::Badge.create!(
  id: 6,
  name: "wise",
  type: "user",
  description: "Wise guy",
  custom_fields: { name: "Wise", points: 10,  image: '/assets/badges/wise.png', created_at: Time.now  }
)

Merit::Badge.create!(
  id: 7,
  name: "cool",
  type: "user",
  description: "Cool guy",
  custom_fields: { name: "Cool", points: 10,  image: '/assets/badges/cool-guy.png', created_at: Time.now  }
)

Merit::Badge.create!(
  id: 8,
  name: "scholar",
  type: "user",
  description: "Scholar",
  custom_fields: { name: "Scholar", points: 10,  image: '/assets/badges/wise.png', created_at: Time.now  }
)

Merit::Badge.create!(
  id: 9,
  name: "fish",
  type: "user",
  description: "Fish",
  custom_fields: { name: "Fish", points: 10,  image: '/assets/badges/fish.png', created_at: Time.now  }
)

Merit::Badge.create!(
  id: 10,
  name: "expert",
  type: "user",
  description: "Expert",
  custom_fields: { name: "Expert", points: 10,  image: '/assets/badges/ninja.png', created_at: Time.now  }
)

Merit::Badge.create!(
  id: 11,
  name: "mentor",
  type: "user",
  description: "Mentor",
  custom_fields: { name: "Mentor", points: 10,  image: '/assets/badges/mentor.png', created_at: Time.now  }
)

