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

  def self.project(name)
    projects.find { |project| project[:name] == name }
  end

  def self.project_path(name)
    project(name).latest_path
  end
end
