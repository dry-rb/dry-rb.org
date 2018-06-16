require "socket"
require "better_errors"
require "slim"
require "lib/redcarpet_renderers"
require "lib/typography_helpers"

use BetterErrors::Middleware

# Settings ---------------------------------------------------------------------

# Private settings
# Pulled from the `.env` in the root directory. Exposed as `ENV["SETTING_NAME"]`
# across all templates/asset environments
activate :dotenv

# Public site settings
# Pulled from `site.yaml`. Exposed as `site.setting_name` in templates.
set :site, YAML::load_file(File.dirname(__FILE__) + "/site.yaml").to_hashugar

Time.zone = config.site.timezeone

set :site_title, "dry-rb"
set :site_url, "http://dry-rb.org"
set :site_description, "dry-rb is a collection of micro-libraries, each intended to encapsulate a common task in Ruby."
set :site_keywords, "dry-rb, ruby, micro-libraries"

# Configuration ----------------------------------------------------------------

# General configuration for Middleman assets
set :build_dir,  "docs"
set :css_dir,    "assets/stylesheets"
set :js_dir,     "assets/javascripts"
set :images_dir, "images"
set :fonts_dir,  "fonts"
set :vendor_dir, "vendor"

activate :external_pipeline,
  name: :webpack,
  command:
    (if build?
      "./node_modules/webpack/bin/webpack.js --bail"
    else
      "./node_modules/webpack/bin/webpack.js --watch -d"
    end),
  source: ".tmp/dist",
  latency: 1

activate :syntax, css_class: "syntax"

set :markdown_engine, :redcarpet
set :markdown,        fenced_code_blocks: true,
                      autolink: true,
                      smartypants: true,
                      hard_wrap: true,
                      smart: true,
                      superscript: true,
                      no_intra_emphasis: true,
                      lax_spacing: true,
                      with_toc_data: true,
                      tables: true

Slim::Embedded.set_options(
  markdown: {
    autolink: true,
    fenced_code_blocks: true,
    hard_wrap: true,
    lax_spacing: true,
    no_intra_emphasis: true,
    smart: true,
    smartypants: true,
    superscript: true,
    tables: true,
    with_toc_data: true
  }
)

# Activate various extensions --------------------------------------------------

# Make sure that livereload uses the host FQDN so we can use it across network
activate :livereload, host: 'localhost'

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes
# Time.zone = "UTC"

###
# Blog settings
###

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  blog.prefix = "/news"

  # Matcher for blog source files
  blog.sources = "{year}-{month}-{day}.html"

  # blog.taglink = "tags/{tag}.html"
  blog.layout = "news-single"
  blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  # blog.default_extension = ".markdown"

  # blog.tag_template = "tag.html"
  # blog.calendar_template = "calendar.html"

  # Enable pagination
  blog.paginate = true
  blog.per_page = 20
  blog.page_link = "page/{num}"
end

page "/feed.xml", layout: false

# Output everything as a `/directory/index.html` instead of individual files
activate :directory_indexes

# Page options -----------------------------------------------------------------

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
#   page "/path/to/file.html", layout: :otherlayout
# With no layout
# page "/path/to/file.html", layout: false
#
# A path which all have the same layout:
# With alternative layout
# page "/path/to/file.html", layout: :otherlayout
#
#   with_layout :admin do
#     page "/admin/*"
#   end
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files:
#   page "/this-page-has-no-template.html", proxy: "/template-file.html" do
#     @which_fake_page = "Rendering a fake page with a variable"
#   end
# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

page "/", layout: "base"
page "/news/*", layout: "news-single"
page "*.json"

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

helpers do
  VERSION_REGEX = %r{([\d\.]+)\/}

  def page_title
    [config[:site_title], page_header, current_page.data.title].compact.join(' - ')
  end

  def page_header
    current_page.data.name || recursive_name(current_page)
  end

  def recursive_name(page)
    return nil unless page
    return page.data.name if page.data.name

    recursive_name(page.parent)
  end

  def github_link
    content_tag(:a, href: "https://github.com/dry-rb/#{current_page.data.name}") do
      "View #{current_page.data.name} on GitHub"
    end
  end

  def nav
    if current_gem && has_version?(current_resource.url)
      url = "#{current_resource.url.split('/')[0..3].join('/')}/"
    else
      url = "#{current_resource.url.split('/')[0..2].join('/')}/"
    end

    root = sitemap.resources.detect { |page| page.url == url }

    raise "page for #{url} not found" unless root

    content_tag(:ul, nav_link(root, false))
  end

  def nav_header
    name = current_resource.url.split('/')[2]
    content_tag(:h2, name)
  end

  def nav_link(page, nest = true)
    content_tag(:li) do
      classes = []
      classes << 'active' if current_resource.url == page.url

      url = has_version?(page.url) ? page.url : set_version(page.url, gem_versions['fallback'])

      html = link_to(page.data.title, url, class: classes.join(' '))

      if page.data.sections
        links = nav_links(page.children, page).html_safe
        html << (nest ? content_tag(:ul, links) : links)
      end

      html
    end
  end

  def nav_links(pages, root)
    root.data.sections.map do |name|
      page = pages.sort_by { |s| s.path.length }.detect { |r| r.path.include?(name) }

      raise "section #{name} not found" unless page
      nav_link(page)
    end.join
  end

  # Returns a list of pages matching a specific type
  def list_pages_by_type(type)
    return [] unless type

    sitemap.resources.select do |resource|
      resource.data.type == type
    end.sort_by { |resource| resource.data.order }
  end

  # Return a list of pages matching a specific group
  def list_pages_by_group(group)
    return [] unless group

    sitemap.resources.select do |resource|
      resource.data.group == group
    end.sort_by { |resource| resource.data.order }
  end

  def page
    current_resource
  end

  def site
    config.site
  end

  def partial(name)
    super("partials/#{name}")
  end

  def author_url
    author = site.authors[current_page.data.author]
    link_to author.name, author.url
  end

  def current_gem
    current_page.data.name
  end

  def gem_versions(gem = current_gem)
    data.versions.fetch(gem, {})
  end

  def versions_match?(v1, v2)
    fallback = gem_versions['fallback']
    v1 == v2 || v1.nil? && v2 == fallback || v2.nil? && v1 == fallback
  end

  def has_version?(url)
    !extract_version(page.url).nil?
  end

  # Convert this config:
  #
  # versions:
  # - "0.4"
  # - code: "1.0"
  #   name: "1.0 beta3"
  #
  # into this:
  #
  # [{code: "0.4", name: "0.4"}, {code: "1.0", name: "1.0 beta3"}]
  def version_variants(gem = current_gem)
    gem_versions(gem).fetch('versions', []).map do |version|
      if version.is_a?(String)
        { code: version, name: version }
      else
        { code: version['code'], name: version['name'] }
      end
    end
  end

  def current_version(gem = current_gem)
    versions = gem_versions(gem)

    versions['current']
  end

  def extract_version(url)
    url[VERSION_REGEX, 1]
  end

  def version
    extract_version(current_path) || gem_versions['fallback']
  end

  def versions_available?
    !gem_versions.empty?
  end

  def set_version(url, new_version)
    return url unless versions_available?

    version = extract_version(url)

    if version
      url.gsub(VERSION_REGEX, new_version)
    else
      parts = url.split('/')

      [
        *parts[0..2],
        new_version,
        *parts[3..-1]
      ].join('/')
    end
  end
end

helpers TypographyHelpers

# Build-specific configuration
configure :build do
  activate :gzip
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
end
