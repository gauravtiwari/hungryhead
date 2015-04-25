json.comment do
  json.(@comment, :id, :user_id, :parent_id, :commentable_id, :commentable_type, :created_at)
  json.comment markdownify(@comment.body)
  json.user_url profile_card_path(@comment.user)
  json.name @comment.user.name
  json.is_owner current_user == @comment.user
  json.uuid SecureRandom.hex(4)
  json.avatar @comment.user.avatar.url(:avatar)
  json.vote_url like_path(votable_type: @comment.class.to_s, votable_id: @comment.id)
  json.voted @comment.voters_ids.members.include? current_user.id.to_s
  json.user_name_badge @comment.user.first_name.first + @comment.user.last_name.first
  json.votes_count @comment.votes_counter.value
end
