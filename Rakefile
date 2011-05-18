require 'rubygems'

# Gay as hell jeweler workaround

require 'psych'
YAML::ENGINE.yamler = 'psych'

require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "rulebook"
  gem.homepage = "http://github.com/c00lryguy/rulebook"
  gem.license = "MIT"
  gem.summary = %Q{Define methods with regex for dynamic methods.}
  gem.description = %Q{Allows you to define a set of 'rules' or dynamic methods to apply to a class.}
  gem.email = "c00lryguy@gmail.com"
  gem.authors = ["Ryan Lewis"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  gem.add_runtime_dependency 'meta_tools', '> 0.1'
  gem.add_development_dependency 'rake', '> 0.0.0'
  gem.add_development_dependency 'riot', '> 0.0.0'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs.concat ['lib', 'test']
  t.pattern = 'test/**/test_*.rb'
  t.verbose = false
end
task :default => :test