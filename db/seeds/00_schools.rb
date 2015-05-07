#this is seeds file for loading test schools
#into db
ActiveRecord::Base.transaction do

  School.destroy_all

  School.create!(
    name: 'Lancaster University',
    location_list: 'Lancaster',
    cover: File.new('/Users/gaurav/HungryHead/hungryhead_school_app/app/assets/images/photo1.jpg'),
    logo: File.new('/Users/gaurav/HungryHead/hungryhead_school_app/app/assets/images/lancaster-logo.png'),
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@lancs.ac.uk',
    website: 'lancs.ac.uk'
  )

  School.create!(
    name: 'Manchester University',
    location_list: 'Manchester',
    cover: File.new('/Users/gaurav/HungryHead/hungryhead_school_app/app/assets/images/photo2-copy.jpg'),
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@mancs.ac.uk',
    website: 'mancs.ac.uk'
  )

  School.create!(
    name: 'Imperial College London',
    location_list: 'London',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@icl.ac.uk',
    website: 'icl.ac.uk'
  )

  School.create!(
    name: 'Cambridge University',
    location_list: 'Cambridge',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@cam.ac.uk',
    website: 'cam.ac.uk'
  )

  School.create!(
    name: 'Salford University',
    location_list: 'Salford',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@salford.ac.uk',
    website: 'salford.ac.uk'
  )

  School.create!(
    name: 'University of central Lancashire',
    location_list: 'Preston',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@uclan.ac.uk',
    website: 'uclan.ac.uk'
  )

  School.create!(
    name: 'Manchester metropolitan university',
    location_list: 'Manchester',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@mmu.ac.uk',
    website: 'mmu.ac.uk'
  )

  School.create!(
    name: 'Oxford University',
    location_list: 'Oxford',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@oxford.ac.uk',
    website: 'oxford.ac.uk'
  )

  School.create!(
    name: 'University college london',
    location_list: 'London',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@ucl.ac.uk',
    website: 'ucl.ac.uk'
  )

  School.create!(
    name: 'Bristol University',
    location_list: 'Bristol',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@bristol.ac.uk',
    website: 'bristol.ac.uk'
  )

end