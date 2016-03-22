desc "Start middleman"
task :watch do
  system 'middleman'
end

desc "Build the site with middleman"
task :build do
  system 'middleman build'
end

namespace :assets do
  # Heroku will automatically detect and run this task
  task :precompile do
    sh "middleman build"
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
