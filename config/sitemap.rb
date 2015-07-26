# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://hungryhead.co"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  add '/learn-more-about-hungryhead'
  add '/why-hungryhead'
  add '/request-invite'
  add '/community-guidelines'
  add '/get-support'

  add '/privacy-policy'
  add '/cookies-policy'
  add '/get-started'
  add '/product-tour'
  add '/terms-of-use'
  add '/our-story'
  add '/how-it-works'
  add '/join'
  add '/login'
  add '/help'

  Help::Category.find_each do |category|
    add Help::Engine.routes.url_helpers.help_category_path(category), :lastmod => category.updated_at
  end

end
