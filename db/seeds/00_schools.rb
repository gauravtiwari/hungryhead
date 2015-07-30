#this is seeds file for loading test schools
#into db
ActiveRecord::Base.transaction do

  School.destroy_all

  School.create!(
    name: 'Lancaster University',
    location_list: 'Lancaster',
    description: "We’re ranked as the best university in the North West by the Guardian, Sunday Times and Complete University Guide.
    We’ve also won the 'Best University Halls' award for the last six years running, and have been named the best value for money university in England.",
    email: 'admin@lancaster.ac.uk',
    domain: 'lancaster.ac.uk',
    user_id: 1,
    website_url: 'lancaster.ac.uk'
  )

  School.create!(
    name: 'Manchester University',
    location_list: 'Manchester',
    description: "Our vision at The University of Manchester is to make our institution one of the top 25 research universities in the world by 2020.",
    email: 'admin@manchester.ac.uk',
    domain: 'manchester.ac.uk',
    user_id: 1,
    website_url: 'manchester.ac.uk'
  )

  School.create!(
    name: 'Imperial College London',
    location_list: 'London',
    description: "Imperial is a science-based institution, consistently rated amongst the world's best universities.",
    email: 'admin@imperial.ac.uk',
    domain: 'imperial.ac.uk',
    user_id: 1,
    website_url: 'imperial.ac.uk'
  )

  School.create!(
    name: 'Cambridge University',
    location_list: 'Cambridge',
    description: "With more than 18,000 students from all walks of life and all corners of the world, nearly 9,000 staff, 31 Colleges and 150 Departments, Faculties, Schools and other institutions, no two days are ever the same at the University of Cambridge.",
    email: 'admin@cam.ac.uk',
    domain: 'cam.ac.uk',
    user_id: 1,
    website_url: 'cam.ac.uk'
  )

  School.create!(
    name: 'Salford University',
    location_list: 'Salford',
    description: "The University of Salford is a friendly, vibrant and pioneering University. We continually invest in our campus, facilities and industry partnerships to enhance your student experience and provide opportunities to develop the skills needed to succeed in your career",
    email: 'admin@salford.ac.uk',
    domain: 'salford.ac.uk',
    user_id: 1,
    website_url: 'salford.ac.uk'
  )

  School.create!(
    name: 'University of central Lancashire',
    location_list: 'Preston',
    description: "The University of Central Lancashire (UCLan) in Preston was founded in 1828 as the Institution for the Diffusion of Knowledge.",
    email: 'admin@uclan.ac.uk',
    domain: 'uclan.ac.uk',
    user_id: 1,
    website_url: 'uclan.ac.uk'
  )

  School.create!(
    name: 'Manchester Metropolitan University',
    location_list: 'Manchester',
    description: "Manchester Metropolitan University was awarded university status in 1992 and is part of the largest higher education campus in the UK and one of the most extensive education centres in Europe.",
    email: 'admin@mmu.ac.uk',
    domain: 'mmu.ac.uk',
    user_id: 1,
    website_url: 'mmu.ac.uk'
  )

  School.create!(
    name: 'Oxford University',
    location_list: 'Oxford',
    description: "Oxford is a world-leading centre of learning, teaching and research and the oldest university in the English-speaking world.",
    email: 'admin@ox.ac.uk',
    domain: 'ox.ac.uk',
    user_id: 1,
    website_url: 'ox.ac.uk'
  )

  School.create!(
    name: 'University College London',
    location_list: 'London',
    description: "UCL was founded in 1826 to open up university education in England to those who had been excluded from it. In 1878, it became the first university in England to admit women students on equal terms with men.",
    email: 'admin@ucl.ac.uk',
    domain: 'ucl.ac.uk',
    user_id: 1,
    website_url: 'ucl.ac.uk'
  )

  School.create!(
    name: 'Bristol University',
    location_list: 'Bristol',
    description: "Bristol University is internationally renowned, ranked in the top 30 universities globally (QS World University Rankings), due to its outstanding teaching and research, its superb facilities and highly talented students and staff.",
    email: 'admin@bristol.ac.uk',
    domain: 'bristol.ac.uk',
    user_id: 1,
    website_url: 'bristol.ac.uk'
  )

end