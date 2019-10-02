# frozen_string_literal: true

$LOAD_PATH.unshift(Pathname(__dir__).join('lib').realpath)

require 'site'

desc 'Start middleman'
task :watch do
  system 'middleman'
end

desc 'Build the site with middleman'
task :build do
  system 'middleman build'
end

namespace :projects do
  desc 'Symlink project sources'
  task :symlink do
    site = Middleman::Docsite

    projects = site.projects

    projects.select(&:repo?).each do |project|
      site.clone_repo(project)
      site.symlink_repo(project, branch: 'docsite-1.0')
    end
  end
end
