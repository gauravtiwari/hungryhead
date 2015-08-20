json.comments @comments.each do |comment|
  json.cache! [@commentable, comment], expires_in: 2.hours do
    json.(comment, :id, :commentable_id, :commentable_type, :created_at)
    json.comment markdownify(comment.body)
    json.user_id comment.user.uid
    json.uuid SecureRandom.hex(10) + comment.user.uid
    json.is_owner current_user == comment.user
    json.voted comment.voted?(current_user)
    json.votes_count comment.votes_counter.value
    json.vote_url voters_votes_path(votable_type: @commentable.class.name, votable_id: @commentable.uuid)
    json.name comment.user.name
    json.avatar comment.user.get_avatar
    json.user_name_badge comment.user.name_badge
  end
end


if @comments.next_page
  json.comments_path comments_path(commentable_type: @commentable.class.to_s, id: @commentable.uuid, page: @comments.next_page)
end


