json.voted @votable.voted?(current_user)
json.url vote_path(votable_type: @votable.class.to_s, votable_id: @votable.id)
json.votes_count @votable.votes_counter.value
