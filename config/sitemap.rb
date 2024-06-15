SitemapGenerator::Sitemap.default_host = "https://moto-tokyo.com"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.ping_search_engines = false

SitemapGenerator::Sitemap.create do
  add '/', changefreq: 'weekly', priority: 1.0
  add '/about', changefreq: 'monthly', priority: 0.8
  add '/contact', changefreq: 'monthly', priority: 0.3
  add '/spots/spots', changefreq: 'weekly', priority: 0.8
  add '/map_view/new', changefreq: 'weekly', priority: 0.8
  add '/searches/new', changefreq: 'monthly', priority: 0.5
  
  Spot.find_each do |spot|
    add spot_path(spot), changefreq: 'weekly', priority: 0.9, lastmod: spot.updated_at
  end
end