#this is seeds file for loading test users
#into db
User.create!(
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
   role: 1,
   market_list: "Education, Social, Entrepreneruship",
   settings: {theme: 'solid', idea_notifications: true, feedback_notifications: true, investment_notifications: true, follow_notifications: true, post_notifications: true, weekly_mail: true},
   confirmed_at: Time.now
 )
