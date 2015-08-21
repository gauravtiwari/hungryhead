json.comment do
  json.cache! [@commentable, comment], expires_in: 2.hours do
    json.(comment, :id, :parent_id, :commentable_id, :commentable_type, :created_at)
    json.comment markdownify(comment.body)
    json.user_url profile_card_path(comment.user)
    json.name comment.user.name
    json.user_id comment.user.uid
    json.uuid SecureRandom.hex(10) + comment.user.uid
    json.avatar comment.user.get_avatar
    json.voted voted?(comment)
    json.vote_url voters_votes_path(votable_type: @commentable.class.name, votable_id: @commentable.uuid)
    json.user_name_badge comment.user.name_badge
    json.votes_count comment.votes_counter.value
  end
end
