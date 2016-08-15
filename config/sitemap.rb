# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://hungryhead.co"
SitemapGenerator::Sitemap.create do
  add '/learn-about-hungryhead'
  add '/why-hungryhead'
  add '/our-story'
  add '/product-tour'
  add '/how-it-works'
  add '/community-guidelines'
  add '/get-started'
  add '/product-tour/gamification'
  add '/product-tour/collaboration'
  add '/join'
  add '/privacy-policy'
  add '/cookies-policy'
  add '/terms-of-service'
  add '/help'

  Help::Category.find_each do |category|
    add Help::Engine.routes.url_helpers.help_category_path(category), :lastmod => category.updated_at
  end
end
