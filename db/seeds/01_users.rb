#this is seeds file for loading test users
#into db
ActiveRecord::Base.transaction do

  User.find_by_slug('gaurav').destroy! if User.find_by_slug('gaurav').present?

  User.create!(
    name: 'Gaurav Tiwari',
    first_name: 'Gaurav',
    last_name: 'Tiwari',
    username: 'gaurav',
    password: 'hungryheaduser',
    email: 'gaurav@hungryhead.co',
    admin: true,
    role: 0,
    school_id: 1,
    confirmed_at: Time.now
  )

end