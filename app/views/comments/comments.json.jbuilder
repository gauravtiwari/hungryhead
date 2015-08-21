
json.form action: comments_path, commentable_id: record.uuid, commentable_type: record.class.to_s

json.comments comments.each do |comment|
  json.cache! [ @commentable, comment], expires_in: 2.hours do
    json.(comment, :id, :commentable_id, :commentable_type, :created_at)
    json.comment markdownify(comment.body)
    json.user_id comment.user.uid
    json.vote_url voters_votes_path(votable_type: @commentable.class.name, votable_id: @commentable.uuid)
    json.uuid SecureRandom.hex(10) + comment.user.uid
    json.is_owner current_user == comment.user
    json.voted voted?(comment)
    json.votes_count comment.votes_counter.value
    json.user_url  profile_card_path(comment.user)
    json.name comment.user.name
    json.user_name_badge comment.user.name_badge
    json.avatar comment.user.get_avatar
  end
end
