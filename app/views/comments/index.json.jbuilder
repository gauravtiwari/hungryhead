json.comments @comments.each do |comment|
  json.cache! [@commentable, comment], expires_in: 2.hours do
    json.(comment, :id, :commentable_id, :commentable_type, :created_at)
    json.comment markdownify(comment.body)
    json.user_id comment.fetch_user.uid
    json.vote_url vote_path(votable_type: comment.class.to_s, votable_id: comment.id)
    json.uuid SecureRandom.hex(10)
    json.is_owner current_user == comment.fetch_user
    json.voted comment.voted?(current_user)
    json.votes_count comment.votes_counter.value
    json.user_url  profile_card_path(comment.fetch_user)
    json.name comment.fetch_user.name
    json.avatar comment.fetch_user.avatar.url(:avatar)
    json.user_name_badge comment.fetch_user.user_name_badge
  end
end


if @comments.next_page
  json.comments_path comments_path(commentable_type: @commentable.class.to_s, id: @commentable.uuid, page: @comments.next_page)
end


