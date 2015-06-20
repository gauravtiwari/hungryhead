json.comment do
  json.cache! [comment.commentable, 'comments', comment], expires_in: 2.hours do
    json.(comment, :id, :parent_id, :commentable_id, :commentable_type, :created_at)
    json.comment markdownify(comment.body)
    json.user_url profile_card_path(comment.user)
    json.name comment.user.name
    json.user_id comment.user.uid
    json.uuid SecureRandom.hex(10)
    json.avatar comment.user.avatar.url(:avatar)
    json.vote_url vote_path(votable_type: comment.class.to_s, votable_id: comment.id)
    json.voted comment.voted?(current_user)
    json.user_name_badge comment.user.first_name.first + comment.user.last_name.first
    json.votes_count comment.votes_counter.value
  end
end
