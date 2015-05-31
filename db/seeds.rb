# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


	Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each { |seed| load seed }

	hobbies = File.read("#{Rails.root}/dump-data/hobbies.json")

	data_hash = JSON.parse(hobbies)
	Hobby.destroy_all
	data_hash.each do |tag|
		if Hobby.find_by_slug("#{tag.parameterize}").empty?
			Hobby.new(name: tag, description: tag, description: tag).save
		end
	end

	markets = File.read("#{Rails.root}/dump-data/markets.json")

	data_hash = JSON.parse(markets)
	Market.destroy_all
	data_hash.each do |tag|
		if Market.find_by_slug("#{tag.parameterize}").empty?
			Market.new(name: tag, description: tag, description: tag).save
		end
	end

	locations = File.read("#{Rails.root}/dump-data/locations.json")

	data_hash = JSON.parse(locations)
	Location.destroy_all
	data_hash.each do |tag|
		if Location.find_by_slug("#{tag.parameterize}").empty?
			Location.new(name: tag, description: tag, description: tag).save
		end
	end

	subjects = File.read("#{Rails.root}/dump-data/subjects.json")

	data_hash = JSON.parse(subjects)
	Subject.destroy_all
	data_hash.each do |tag|
		if Subject.find_by_slug("#{tag.parameterize}").empty?
			Subject.new(name: tag, description: tag, description: tag).save
		end
	end
