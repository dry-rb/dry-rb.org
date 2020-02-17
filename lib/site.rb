require 'middleman/docsite'
require 'html-proofer'

require 'site/project'
require 'site/markdown'

Middleman::Docsite.configure do |config|
  config.root = Pathname(__dir__).join('..').realpath.freeze
  config.project_class = Site::Project
end

module Site
  def self.projects
    Middleman::Docsite.projects
  end

  def self.project(name)
    projects.find { |project| project[:name] == name }
  end

  def self.project_path(name)
    project(name).latest_path
  end

  def self.check_links(opts = {})
    HTMLProofer.check_directory('docs',
      { build_dir: 'docs',
        assume_extension: true,
        allow_hash_href: true,
        empty_alt_ignore: true }.merge(opts)
    ).run
  rescue => e
    puts e.message
    false
  end
end
