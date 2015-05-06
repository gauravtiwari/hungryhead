json.name friend.name
json.avatar friend.avatar.url(:avatar)
json.user_name_badge friend.user_name_badge
json.mini_bio friend.mini_bio
json.uuid SecureRandom.hex(10)
json.followed followed?(friend)
