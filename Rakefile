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

namespace :serve do
  desc 'Serve the production build of the site'
  task dist: :build do
    system 'caddy file-server --root docs --listen :2015' || raise('Caddy failed to start, install with: brew install caddy')
  end
end

namespace :projects do
  desc 'Symlink project sources'
  task :symlink do
    site = Middleman::Docsite

    projects = site.projects

    projects.select(&:repo?).each do |project|
      project.versions.each do |version|
        site.clone_repo(project, branch: version[:branch])
        site.symlink_repo(project, version)
      end
    end
  end
end

desc 'Check all links'
task :check_links do
  Site.check_links(file_ignore: [/blog/])
end

namespace :check_links do
  desc 'Check internal links'
  task :internal do
    Site.check_links(disable_external: true, file_ignore: [/blog/]) or exit(1)
  end

  desc 'Check external links'
  task :external do
    Site.check_links(disable_internal: true, file_ignore: [/blog/]) or exit(1)
  end
end
