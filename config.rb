# frozen_string_literal: true

require 'socket'
require 'better_errors'
require 'slim'

$LOAD_PATH.unshift(Pathname(__dir__).join('lib').realpath)

require 'byebug' if ENV['DEBUG']
require 'site'

use BetterErrors::Middleware

# Settings ---------------------------------------------------------------------

# Private settings
# Pulled from the `.env` in the root directory. Exposed as `ENV["SETTING_NAME"]`
# across all templates/asset environments
activate :dotenv

# Public site settings
# Pulled from `site.yaml`. Exposed as `site.setting_name` in templates.
set :site, YAML.load_file(File.dirname(__FILE__) + '/site.yaml').to_hashugar

Time.zone = config.site.timezeone

set :site_title, 'dry-rb'
set :site_url, 'http://dry-rb.org'
set :site_description, 'dry-rb is a collection of micro-libraries, each intended to encapsulate a common task in Ruby.'
set :site_keywords, 'dry-rb, ruby, micro-libraries'

# Configuration ----------------------------------------------------------------

# General configuration for Middleman assets
set :build_dir,  'docs'
set :css_dir,    'assets/stylesheets'
set :js_dir,     'assets/javascripts'
set :images_dir, 'images'
set :fonts_dir,  'fonts'
set :vendor_dir, 'vendor'

activate :external_pipeline,
         name: :webpack,
         command:
           (if build?
              './node_modules/webpack/bin/webpack.js --bail --mode=production'
            else
              './node_modules/webpack/bin/webpack.js --watch -d'
           end),
         source: '.tmp/dist',
         latency: 1

activate :syntax, css_class: 'syntax'

set :markdown_engine, :redcarpet

set(
  :markdown,
  renderer: Site::Markdown::Renderer,
  fenced_code_blocks: true,
  autolink: true,
  smartypants: true,
  hard_wrap: true,
  smart: true,
  superscript: true,
  no_intra_emphasis: true,
  lax_spacing: true,
  with_toc_data: true,
  tables: true
)

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

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes
# Time.zone = "UTC"

###
# Blog settings
###

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  blog.prefix = '/news'

  # Matcher for blog source files
  blog.sources = '{year}-{month}-{day}.html'

  # blog.taglink = "tags/{tag}.html"
  blog.layout = 'news-single'
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
  blog.page_link = 'page/{num}'
end

page '/feed.xml', layout: false

# Output everything as a `/directory/index.html` instead of individual files
activate :directory_indexes

page '/', layout: 'base'
page '/news/*', layout: 'news-single'
page '*.json'

Middleman::Docsite.projects.each do |project|
  proxy(
    "/gems/#{project.name}/index.html",
    '/gem-index-redirect.html',
    locals: { path: project.latest_path },
    layout: false,
    ignore: true
  )
end

proxy('/gems/index.html', 'gems-index.html')

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

helpers do
  VERSION_REGEX = %r{([\d\.]+)\/}.freeze

  def page_title
    [config[:site_title], page_header, current_page.data.title].compact.join(' - ')
  end

  def page_header
    if current_project
      "#{gem_name} #{current_version_name}"
    else
      gem_name || recursive_name(current_page)
    end
  end

  def current_version_name
    current_version == "master" ? current_version : "v#{current_version}"
  end

  def recursive_name(page)
    return nil unless page
    return page.data.name if page.data.name

    recursive_name(page.parent)
  end

  def github_link
    content_tag(:a, href: github_url) do
      "View #{gem_name} on GitHub"
    end
  end

  def edit_gem_page_url
    file_path = current_resource.url.split('/')[4..-1].join('/')
    file_path = file_path.empty? ? 'index' : file_path
    "#{github_url}/edit/#{current_branch}/docsite/source/#{file_path}.html.md"
  end

  def github_url
    "https://github.com/dry-rb/#{gem_name}"
  end

  def current_branch
    current_project.versions.find { |version| version[:value] == current_version }[:branch]
  end

  def nav
    url =
      if current_project && has_version?(current_resource.url)
        current_resource.url.split('/')[0..3].join('/')
      else
        current_resource.url.split('/')[0..2].join('/')
      end

    root = sitemap.resources.find { |page| page.url == "#{url}/" }

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

      url =
        if has_version?(page.url)
          page.url
        else
          set_version(page.url, current_project.fallback_version)
        end.gsub(%r{/$}, '').gsub('//', '/')

      html = link_to(page.data.title, url, class: classes.join(' '))

      if page.data.sections
        links = nav_links(page.children, page).html_safe
        html << (nest ? content_tag(:ul, links) : links)
      end

      html
    end
  end

  def nav_links(pages, root)
    root.data.sections.map { |name|
      page = pages.sort_by { |s| s.path.length }.detect { |r| r.path.include?(name) }

      raise "section #{name} not found" unless page

      nav_link(page)
    }.join
  end

  # Returns a list of pages matching a specific type
  def list_pages_by_type(type)
    return [] unless type

    sitemap.resources
      .select { |resource| resource.data.type == type }
      .sort_by { |resource| resource.data.order }
  end

  # Return a list of pages matching a specific group
  def list_pages_by_group(group)
    return [] unless group

    sitemap.resources
      .select { |resource| resource.data.group == group }
      .sort_by { |resource| resource.data.order }
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

  def current_project
    @current_project ||= Middleman::Docsite.projects.detect { |p| p.name == gem_name }
  end

  def has_version?(_url)
    !extract_version(page.url).nil?
  end

  def extract_version(url)
    url[VERSION_REGEX, 1] || "master"
  end

  def current_version
    extract_version(current_path)
  end

  def gem_name
    current_page.data.name
  end

  def set_version(url, new_version)
    return url unless current_project.versions.empty?

    version = extract_version(url)

    if version
      url.gsub(VERSION_REGEX, "#{new_version}/")
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

helpers Site::Helpers

# Build-specific configuration
configure :build do
  activate :gzip
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
end
