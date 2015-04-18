json.share do
  json.shared current_user.shared? @shareable
  json.count @shareable.shares_count
end