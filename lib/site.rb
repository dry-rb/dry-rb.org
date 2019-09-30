require 'middleman/docsite'
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
end
