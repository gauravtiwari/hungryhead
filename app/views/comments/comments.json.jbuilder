
json.form action: comments_path, csrf_param: request_forgery_protection_token, csrf_token: form_authenticity_token,
commentable_id: record.id, commentable_type: record.class.to_s

json.comments comments.each do |comment|
  json.cache! ['comment', comment], expires_in: 10.minutes do
    json.(comment, :id, :user_id, :commentable_id, :commentable_type, :created_at)
    json.comment markdownify(comment.body)
    json.vote_url like_path(votable_type: comment.class.to_s, votable_id: comment.id)
    json.uuid SecureRandom.hex(4)
    json.is_owner current_user == comment.user
    json.voted current_user.voted_for? comment
    json.votes_count comment.cached_votes_total
    json.user_url  profile_card_path(comment.user)
    json.name comment.user.name
    json.avatar comment.user.avatar.url(:avatar)

    json.childrens comment.children.each do |comment|
        json.(comment, :id, :user_id, :commentable_id, :parent_id, :commentable_type, :created_at)
        json.comment markdownify(comment.body)
        json.vote_url like_path(votable_type: comment.class.to_s, votable_id: comment.id)
        json.uuid SecureRandom.hex(4)
        json.is_owner current_user == comment.user
        json.voted current_user.voted_for? comment
        json.votes_count comment.cached_votes_total
        json.user_url  profile_card_path(comment.user)
        json.name comment.user.name
        json.avatar comment.user.avatar.url(:avatar)
    end
  end
end
