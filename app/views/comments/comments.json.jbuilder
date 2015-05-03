
json.form action: comments_path, csrf_param: request_forgery_protection_token, csrf_token: form_authenticity_token,
commentable_id: record.id, commentable_type: record.class.to_s

json.comments comments.each do |comment|
  json.cache! ['comment', comment], expires_in: 10.minutes do
    json.(comment, :id, :user_id, :commentable_id, :commentable_type, :created_at)
    json.comment markdownify(comment.body)
    json.vote_url vote_path(votable_type: comment.class.to_s, votable_id: comment.id)
    json.uuid SecureRandom.hex(10)
    json.is_owner current_user == comment.user
    json.voted comment.voted?(current_user)
    json.votes_count comment.votes_counter.value
    json.user_url  profile_card_path(comment.user)
    json.name comment.user.name
    json.user_name_badge comment.user.first_name.first + comment.user.last_name.first
    json.avatar comment.user.avatar.url(:avatar)
  end
end
