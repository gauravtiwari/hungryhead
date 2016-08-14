class Rack::Attack
  banned = %w[182.89.62.3 59.57.171.132 61.178.78.96 113.239.148.130 180.114.70.212].to_set

  ### Throttle Spammy Clients ###
  # Key: "rack::attack:#{Time.now.to_i/:period}:req/ip:#{req.ip}"
  Rack::Attack.throttle('req/ip', :limit => 300, :period => 5.minutes) do |req|
    req.ip unless req.path.starts_with?('/assets')
  end

  ### Prevent Brute-Force Login Attacks ###
  Rack::Attack.throttle('logins/ip', :limit => 5, :period => 20.seconds) do |req|
    if req.path == '/login' && req.post?
      req.ip
    end
  end

  Rack::Attack.throttle("logins/email", :limit => 5, :period => 20.seconds) do |req|
    if req.path == '/login' && req.post?
      # return the email if present, nil otherwise
      req.params['email'].presence
    end
  end

  Rack::Attack.throttle("search/query", :limit => 5, :period => 20.seconds) do |req|
    if req.path == '/search?q=g'
      req.ip
    end
  end

  ### Custom Throttle Response ###

  Rack::Attack.blocklist('block spammers') do |req|
    # Requests are blocked if the return value is truthy
    banned.include?(req.ip)
  end
end
