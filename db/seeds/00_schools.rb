#this is seeds file for loading test schools
#into db
ActiveRecord::Base.transaction do

  School.destroy_all

  School.create!(
    name: 'Lancaster University',
    location_list: 'Lancaster',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@lancs.ac.uk',
    domain: 'lancs.ac.uk',
    website_url: 'lancs.ac.uk'
  )

  School.create!(
    name: 'Manchester University',
    location_list: 'Manchester',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@mancs.ac.uk',
    domain: 'mancs.ac.uk',
    website_url: 'mancs.ac.uk'
  )

  School.create!(
    name: 'Imperial College London',
    location_list: 'London',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@icl.ac.uk',
    domain: 'icl.ac.uk',
    website_url: 'icl.ac.uk'
  )

  School.create!(
    name: 'Cambridge University',
    location_list: 'Cambridge',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@cam.ac.uk',
    domain: 'cam.ac.uk',
    website_url: 'cam.ac.uk'
  )

  School.create!(
    name: 'Salford University',
    location_list: 'Salford',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@salford.ac.uk',
    domain: 'salford.ac.uk',
    website_url: 'salford.ac.uk'
  )

  School.create!(
    name: 'University of central Lancashire',
    location_list: 'Preston',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@uclan.ac.uk',
    domain: 'uclan.ac.uk',
    website_url: 'uclan.ac.uk'
  )

  School.create!(
    name: 'Manchester metropolitan university',
    location_list: 'Manchester',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@mmu.ac.uk',
    domain: 'mmu.ac.uk',
    website_url: 'mmu.ac.uk'
  )

  School.create!(
    name: 'Oxford University',
    location_list: 'Oxford',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@oxford.ac.uk',
    domain: 'oxford.ac.uk',
    website_url: 'oxford.ac.uk'
  )

  School.create!(
    name: 'University college london',
    location_list: 'London',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@ucl.ac.uk',
    domain: 'ucl.ac.uk',
    website_url: 'ucl.ac.uk'
  )

  School.create!(
    name: 'Bristol University',
    location_list: 'Bristol',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@bristol.ac.uk',
    domain: 'bristol.ac.uk',
    website_url: 'bristol.ac.uk'
  )

end