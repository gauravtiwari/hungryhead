#this is seeds file for loading test schools
#into db
ActiveRecord::Base.transaction do

  School.destroy_all

  School.create!(
    name: 'Lancaster University',
    location_list: 'Lancaster',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@lancs.ac.uk',
  )

  School.create!(
    name: 'Manchester University',
    location_list: 'Manchester',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@mancs.ac.uk',
  )

  School.create!(
    name: 'Imperial College London',
    location_list: 'London',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@icl.ac.uk',
  )

  School.create!(
    name: 'Cambridge University',
    location_list: 'Cambridge',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@cam.ac.uk',
  )

  School.create!(
    name: 'Salford University',
    location_list: 'Salford',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@salford.ac.uk',
  )

  School.create!(
    name: 'University of central Lancashire',
    location_list: 'Preston',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@uclan.ac.uk',
  )

  School.create!(
    name: 'Manchester metropolitan university',
    location_list: 'Manchester',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@mmu.ac.uk',
  )

  School.create!(
    name: 'Oxford University',
    location_list: 'Oxford',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@oxford.ac.uk',
  )

  School.create!(
    name: 'University college london',
    location_list: 'London',
    description: Forgery::LoremIpsum.words(20),
    email: 'admin@ucl.ac.uk',
  )

end