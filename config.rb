require 'socket'
require 'better_errors'
require 'slim'
require 'lib/redcarpet_renderers'
use BetterErrors::Middleware

# Settings ---------------------------------------------------------------------

# Private settings
# Pulled from the `.env` in the root directory. Exposed as `ENV["SETTING_NAME"]`
# across all templates/asset environments
activate :dotenv

# Public site settings
# Pulled from `site.yaml`. Exposed as `site.setting_name` in templates.
set :site, YAML::load_file(File.dirname(__FILE__) + "/site.yaml").to_hashugar
Time.zone = site.timezeone

# Configuration ----------------------------------------------------------------

# General configuration for Middleman and its sprockets environment
set :partials_dir,    'partials'
set :css_dir,         'assets/stylesheets'
set :js_dir,          'assets/javascripts'
set :images_dir,      'assets/images'
set :fonts_dir,       'assets/fonts'
set :vendor_dir,      'assets/vendor'

after_configuration do
  sprockets.append_path "assets/vendor"
end


set :markdown_engine, :redcarpet
set :markdown,        :fenced_code_blocks => true,
                      :autolink => true,
                      :smartypants => true,
                      :hard_wrap => true,
                      :smart => true,
                      :superscript => true,
                      :no_intra_emphasis => true,
                      :lax_spacing => true,
                      :with_toc_data => true

# Activate various extensions --------------------------------------------------

# Output everything as a `/directory/index.html` instead of individual files
activate :directory_indexes

# Make sure that livereload uses the host FQDN so we can use it across network
activate :livereload, :host => Socket.gethostbyname(Socket.gethostname).first

# Autoprefixer
activate :autoprefixer, browsers: ['last 2 versions', 'ie 8', 'ie 9']

# React
activate :react

# Jasmine testing through middleman-jasmine:
# https://github.com/mrship/middleman-jasmine
activate :jasmine

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Open-graph protocol configuration
activate :ogp do |ogp|
  ogp.namespaces = {
    fb: data.ogp.fb,
    og: data.ogp.og,
    twitter: data.ogp.twitter
  }
end


# Page options -----------------------------------------------------------------

# Example configuration options:
# With no layout:
#
#   page "/path/to/file.html", :layout => false
#
# With alternative layout:
#
#   page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout:
#
#   with_layout :admin do
#     page "/admin/*"
#   end

# Proxy (fake) files:
#   page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#     @which_fake_page = "Rendering a fake page with a variable"
#   end

page "*", :layout => "layouts/base"
page "/news/index.html", :layout => "base"
page "/news/*", :layout => "news-single"
page "*.json"


# Helpers ----------------------------------------------------------------------
# Load helpers from `./lib`
require "lib/typography_helpers"
helpers TypographyHelpers
require "lib/asset_helpers"
helpers AssetHelpers

# Methods defined in the helpers block are available in templates
# Uncomment the below to add custom helpers
# helpers do
#   def some_helper
#     "Helping"
#   end
# end


# Build configuration ----------------------------------------------------------

activate :cloudfront do |cloudfront|
  cloudfront.access_key_id     = ENV['AWS_ACCESS_KEY']
  cloudfront.secret_access_key = ENV['AWS_SECRET_KEY']
  cloudfront.distribution_id   = ENV['CLOUDFRONT_DIST_ID']
  cloudfront.filter            = /.*[^\.gz]$/i
  cloudfront.after_build       = (ENV["TARGET"] == "production")
end

activate :s3_redirect do |s3_redirect|
  s3_redirect.bucket                = ENV['S3_BUCKET']
  s3_redirect.region                = ENV['S3_REGION']
  s3_redirect.aws_access_key_id     = ENV['AWS_ACCESS_KEY']
  s3_redirect.aws_secret_access_key = ENV['AWS_SECRET_KEY']
  s3_redirect.after_build           = true
end

configure :build do
  # Common configuration
  activate :gzip
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash

  # Relative URLs ../etc
  # activate :relative_assets

  activate :imageoptim do |image_optim|
    image_optim.image_extensions = ['*.png', '*.jpg', '*.gif']
  end

    # Production config
  # S3 + CloudFront distribution
  # TARGET=production rake build
  if ENV["TARGET"] == "production"
    activate :asset_host
    set :asset_host, site.cdn_url

    activate :s3_redirect do |s3_redirect|
      s3_redirect.bucket                = ENV['S3_BUCKET']
      s3_redirect.region                = ENV['S3_REGION']
      s3_redirect.aws_access_key_id     = ENV['AWS_ACCESS_KEY']
      s3_redirect.aws_secret_access_key = ENV['AWS_SECRET_KEY']
      s3_redirect.after_build           = true
    end

    activate :s3_sync do |s3_sync|
      s3_sync.bucket                = ENV['S3_BUCKET']
      s3_sync.region                = ENV['S3_REGION']
      s3_sync.aws_access_key_id     = ENV['AWS_ACCESS_KEY']
      s3_sync.aws_secret_access_key = ENV['AWS_SECRET_KEY']
      s3_sync.prefer_gzip           = true
      s3_sync.delete                = true
      s3_sync.after_build           = true
    end

    default_caching_policy max_age: 31449600, public: true
    caching_policy 'text/html', max_age: 7200, must_revalidate: true
    caching_policy 'text/css', max_age: 31449600, public: true
    caching_policy 'application/javascript', max_age: 31449600, public: true
  end
end
