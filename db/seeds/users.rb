#this is seeds file for loading test users
#into db

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
