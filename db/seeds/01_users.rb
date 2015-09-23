#this is seeds file for loading test users
#into db
User.create!(
   name: "Gaurav Tiwari",
   first_name: "Gaurav",
   last_name: "Tiwari",
   username: "gaurav",
   password: 'password',
   avatar: File.new('/Users/gaurav/HungryHead/hungryhead_school_app/app/assets/images/profiles/b.jpg'),
   mini_bio: Forgery::LoremIpsum.words(5),
   school_id: 1,
   location_list: "Lancaster",
   email: "gaurav@gauravtiwari.co.uk",
   fund: {balance: 1000},
   role: 1,
   market_list: "Education, Social, Entrepreneruship",
   settings: {theme: 'solid', idea_notifications: true, feedback_notifications: true, investment_notifications: true, follow_notifications: true, post_notifications: true, weekly_mail: true},
   confirmed_at: Time.now
 )

 User.create!(
   name: "Parul Singh",
   first_name: "Parul",
   last_name: "Singh",
   username: "parul",
   password: 'password',
   avatar: File.new('/Users/gaurav/HungryHead/hungryhead_school_app/app/assets/images/profiles/ba2x.jpg'),
   mini_bio: Forgery::LoremIpsum.words(5),
   school_id: 1,
   location_list: "Lancaster",
   email: "parul.rhl@gmail.com",
   fund: {balance: 1000},
   verified: true,
   role: 4,
   market_list: "Education, Social, Ecommerce",
   settings: {theme: 'primary', idea_notifications: true, feedback_notifications: true, investment_notifications: true, follow_notifications: true, post_notifications: true, weekly_mail: true},
   confirmed_at: Time.now
 )

 User.create!(
   name: "Stuart Logan",
   first_name: "Stuart",
   last_name: "Logan",
   username: "stuart",
   password: 'password',
   mini_bio: Forgery::LoremIpsum.words(5),
   school_id: 2,
   avatar: File.new('/Users/gaurav/HungryHead/hungryhead_school_app/app/assets/images/profiles/avatar2x.jpg'),
   location_list: "Manchester",
   email: "stuart@hungryhead.org",
   fund: {balance: 1000},
   verified: true,
   role: 3,
   market_list: "Education, Entrepreneruship, Music",
   settings: {theme: 'danger', idea_notifications: true, feedback_notifications: true, investment_notifications: true, follow_notifications: true, post_notifications: true, weekly_mail: true},
   confirmed_at: Time.now
 )

 User.create!(
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
   role: 3,
   market_list: "Social, Entrepreneruship, Music",
   settings: {theme: 'danger', idea_notifications: true, feedback_notifications: true, investment_notifications: true, follow_notifications: true, post_notifications: true, weekly_mail: true},
   confirmed_at: Time.now
 )
