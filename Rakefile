desc "Start middleman"
task :watch do
  system 'middleman'
end

desc "Build the site with middleman"
task :build do
  system 'middleman build'
end

desc "Set up as a clean project"
task :setup do
  system 'rm -rf .git'
  system 'mv README.md Skeleton.md'
  system 'git init'
end

namespace :assets do
  # For deploying to heroku
  # It’ll automatically pick up this task
  task :precompile do
    sh "middleman build"
  end

  desc "Pull down latest CSS patterns"
  task :fetch_patterns do
    system 'git clone git@bitbucket.org:icelab/css-patterns.git ./source/assets/stylesheets/patterns'
    system 'rm -rf ./source/assets/stylesheets/patterns/.git'
  end
end

begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end
