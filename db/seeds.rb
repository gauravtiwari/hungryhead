# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

institutions = File.read("#{Rails.root}/dump-data/institutions.json")

data_hash = JSON.parse(institutions)
Institution.destroy_all
data_hash.each do |tag|
	if Institution.find_by_email("#{tag['name'].parameterize}@hungryhead.org").blank?
		Institution.new(name: tag["name"], website: tag["website"], description: tag["name"], email: "#{tag['name'].parameterize}@hungryhead.org").save
	end
end


roles = File.read("#{Rails.root}/dump-data/roles.json")

data_hash = JSON.parse(roles)
Service.destroy_all
data_hash.each do |tag|
	if Service.find_by_slug("#{tag.parameterize}").blank?
		Service.new(name: tag, description: tag, description: tag).save
	end
end

skills = File.read("#{Rails.root}/dump-data/skills.json")

data_hash = JSON.parse(skills)
Skill.destroy_all
data_hash.each do |tag|
	if Skill.find_by_slug("#{tag.parameterize}").blank?
		Skill.new(name: tag, description: tag, description: tag).save
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

technologies = File.read("#{Rails.root}/dump-data/technologies.json")

data_hash = JSON.parse(technologies)
Technology.destroy_all
data_hash.each do |tag|
	if Technology.find_by_slug("#{tag.parameterize}").blank?
		Technology.new(name: tag, description: tag, description: tag).save
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