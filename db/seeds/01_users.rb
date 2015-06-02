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
    role: 0,
    state: 0,
    confirmed_at: Time.now
  )

end