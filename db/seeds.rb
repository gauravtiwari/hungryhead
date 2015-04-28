# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

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

School.create!(
	name: "Lancaster University",
	email: "info@lancas.ac.uk",
	location_list: "Lancaster",
	logo: "assets/lancaster-logo.png",
	cover: "assets/cover_lancs-cover.jpg",
	description: "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ducimus nesciunt ex esse similique quam placeat, possimus ratione animi, non, voluptate consequatur aperiam. Rerum mollitia sequi et molestiae, eius soluta provident!"
)

hobbies = File.read("#{Rails.root}/dump-data/hobbies.json")

data_hash = JSON.parse(hobbies)
Hobby.destroy_all
data_hash.each do |tag|
	if Hobby.find_by_slug("#{tag.parameterize}").blank?
		Hobby.new(name: tag, description: tag, description: tag).save
	end
end

markets = File.read("#{Rails.root}/dump-data/markets.json")

data_hash = JSON.parse(markets)
Market.destroy_all
data_hash.each do |tag|
	if Market.find_by_slug("#{tag.parameterize}").blank?
		Market.new(name: tag, description: tag, description: tag).save
	end
end

locations = File.read("#{Rails.root}/dump-data/locations.json")

data_hash = JSON.parse(locations)
Location.destroy_all
data_hash.each do |tag|
	if Location.find_by_slug("#{tag.parameterize}").blank?
		Location.new(name: tag, description: tag, description: tag).save
	end
end

subjects = File.read("#{Rails.root}/dump-data/subjects.json")

data_hash = JSON.parse(subjects)
Subject.destroy_all
data_hash.each do |tag|
	if Subject.find_by_slug("#{tag.parameterize}").blank?
		Subject.new(name: tag, description: tag, description: tag).save
	end
end