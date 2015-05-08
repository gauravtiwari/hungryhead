json.friends @friends.each do |friend|
    json.partial! 'friend', :friend => friend
end

json.meta do
  json.next_page @friends.next_page
end