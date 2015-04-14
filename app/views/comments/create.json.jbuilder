json.comment do
  json.(@comment, :id, :user_id, :parent_id, :commentable_id, :commentable_type, :created_at)
  json.comment markdownify(@comment.body)
  json.user_url profile_card_path(@comment.user)
  json.name @comment.user.name
  json.is_owner current_user == @comment.user
  json.uuid SecureRandom.hex(4)
  json.avatar @comment.user.avatar.url(:avatar)
  json.vote_url like_path(votable_type: @comment.class.to_s, votable_id: @comment.id)
  json.voted current_user.voted_for? @comment
  json.votes_count @comment.cached_votes_total
end
