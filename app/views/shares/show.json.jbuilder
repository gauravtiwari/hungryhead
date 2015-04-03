json.share do
	json.shareable @shareable.id
	json.count @shareable.shares_count
	json.shared true
end