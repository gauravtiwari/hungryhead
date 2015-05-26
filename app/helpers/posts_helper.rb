module PostsHelper

  def cached_posts user
    list = Redis::List.new("posts:#{user.class.to_s}:#{user.id}", marshal: true)
    if list.empty?
      user.posts.each do |item|
        list << post_json(item)
      end
    end
    list
  end

  def post_json post
    {
      id: post.id,
      title: post.title,
      url: post_path(post),
      excerpt: truncate(post.body, length: 50, escape: false)
    }
  end

end
