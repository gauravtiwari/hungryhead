json.comments @comments.each do |comment|
  json.cache! ['v1', comment], expires_in: 1.minutes do
    json.(comment, :id, :user_id, :commentable_id, :commentable_type, :created_at)
    json.comment markdownify(comment.body)
    json.vote_url vote_path(votable_type: comment.class.to_s, votable_id: comment.id)
    json.uuid SecureRandom.hex(10)
    json.is_owner current_user == comment.user
    json.voted comment.voted?(current_user.id.to_s)
    json.votes_count comment.votes_counter.value
    json.user_url  profile_card_path(comment.user)
    json.name comment.user.name
    json.avatar comment.user.avatar.url(:avatar)
    json.user_name_badge comment.user.first_name.first + comment.user.last_name.first
  end
end


if @comments.next_page
  json.comments_path comments_path(commentable_type: @commentable.class.to_s, id: @commentable.id, page: @comments.next_page)
end


