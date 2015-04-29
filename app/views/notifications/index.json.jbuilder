json.array! @notifications.each do |notification|
  json.partial! "notifications/#{notification.key.to_s.gsub('.', '/')}", locals: {notification: notification}
end