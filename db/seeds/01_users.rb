#this is seeds file for loading test users
#into db
ActiveRecord::Base.transaction do

  User.find_by_slug('adminuser').destroy! if User.find_by_slug('adminuser').present?

  User.create!(
    name: 'Admin User',
    first_name: 'Admin',
    last_name: 'User',
    username: 'adminuser',
    password: 'hungryheaduser',
    email: 'admin@hungryhead.org',
    admin: true,
    confirmed_at: Time.now
  )

  Student.create!(
    name: "Gaurav Tiwari",
    first_name: "Gaurav",
    last_name: "Tiwari",
    username: "gaurav",
    password: 'password',
    mini_bio: Forgery::LoremIpsum.words(5),
    school_id: 1,
    location_list: "Lancaster",
    email: "gaurav@gauravtiwari.co.uk",
    fund: {balance: 1000},
    market_list: "Education, Social, Entrepreneruship",
    settings: {theme: 'primary', idea_notifications: true, feedback_notifications: true, investment_notifications: true, follow_notifications: true, note_notifications: true, weekly_mail: true},
    confirmed_at: Time.now
  )

  Teacher.create!(
    name: "Parul Singh",
    first_name: "Parul",
    last_name: "Singh",
    username: "parul",
    password: 'password',
    mini_bio: Forgery::LoremIpsum.words(5),
    school_id: 1,
    location_list: "Lancaster",
    email: "parul.rhl@gmail.com",
    fund: {balance: 1000},
    verified: true,
    market_list: "Education, Social, Ecommerce",
    settings: {theme: 'primary', idea_notifications: true, feedback_notifications: true, investment_notifications: true, follow_notifications: true, note_notifications: true, weekly_mail: true},
    confirmed_at: Time.now
  )

  Mentor.create!(
    name: "Stuart Logan",
    first_name: "Stuart",
    last_name: "Logan",
    username: "stuart",
    password: 'password',
    mini_bio: Forgery::LoremIpsum.words(5),
    school_id: 2,
    location_list: "Manchester",
    email: "stuart@hungryhead.org",
    fund: {balance: 1000},
    verified: true,
    market_list: "Education, Entrepreneruship, Music",
    settings: {theme: 'danger', idea_notifications: true, feedback_notifications: true, investment_notifications: true, follow_notifications: true, note_notifications: true, weekly_mail: true},
    confirmed_at: Time.now
  )

  Mentor.create!(
    name: "Damien Sheils",
    first_name: "Damien",
    last_name: "Sheils",
    username: "damien",
    mini_bio: Forgery::LoremIpsum.words(5),
    password: 'password',
    school_id: 2,
    location_list: "Manchester",
    email: "damien@hungryhead.org",
    fund: {balance: 1000},
    verified: true,
    market_list: "Social, Entrepreneruship, Music",
    settings: {theme: 'danger', idea_notifications: true, feedback_notifications: true, investment_notifications: true, follow_notifications: true, note_notifications: true, weekly_mail: true},
    confirmed_at: Time.now
  )


  1.upto(10000) { |i|

    Student.create!(
      name: Forgery::Name.full_name,
      first_name: Forgery::Name.first_name,
      last_name: Forgery::Name.last_name,
      username: Forgery::Internet.user_name + i.to_s,
      password: 'password',
      mini_bio: Forgery::LoremIpsum.words(5),
      school_id: [*1..9].sample,
      location_list: Forgery::Address.city,
      email: "test#{i}@hungryhead.org",
      fund: {balance: 1000},
      market_list: Forgery::Name.industry,
      settings: {theme: 'solid', idea_notifications: true, feedback_notifications: true, investment_notifications: true, follow_notifications: true, note_notifications: true, weekly_mail: true},
      confirmed_at: Time.now
    )
  }

end