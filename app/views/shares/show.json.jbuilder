json.share do
  json.shared @shareable.shared? current_user
  json.count @shareable.shares_count
end