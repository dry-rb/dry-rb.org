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
      project.versions.each do |version|
        site.clone_repo(project, branch: version[:branch])
        site.symlink_repo(project, version)
      end
    end
  end

  desc 'Generate docsite branches'
  task :generate_docsite_branches do
    site = Middleman::Docsite

    projects = site.projects

    projects.each do |project|
      site.clone_repo(project, branch: 'master')

      project.versions.each do |version|
        name = project.name
        version_value = version[:value]

        project_dir = site.projects_dir.join('dry-rb.org').join("source/gems/#{name}")
        docs_dir = (path = project_dir.join(version_value)).exist? ? path : project_dir

        tag_names = `cd #{site.projects_dir.join("#{name}/master")} && git tag`
          .split.select { |t| t.start_with?("v#{version_value}") }
          .sort
          .reverse

        source_branch = tag_names.first
        target_branch = "docsite-#{version_value}"

        cmds = []
        cmds << "cd #{site.projects_dir.join(project.name)}/master"
        cmds << "git checkout #{source_branch}"
        cmds << "git checkout -B #{target_branch}"
        cmds << 'mkdir -p docsite/source'
        cmds << "cp -rv #{docs_dir}/* docsite/source"
        cmds << 'git add docsite'
        cmds << "git commit -am 'Add docsite for version #{version_value}'"

        # Uncomment this if you really wanna push to remote
        #
        # cmds << "git push -fu origin #{target_branch}"

        system(cmds.join(' && '))
      end
    end
  end
end
