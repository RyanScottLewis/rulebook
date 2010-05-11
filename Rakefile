require 'rubygems'
require 'rake'

#==================#
#===--- Test ---===#
#==================#

require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.pattern = 'test/**/test_*.rb'
  t.verbose = true
end
task :test => :check_dependencies
# task :default => :test

#===================#
#===--- RSpec ---===#
#===================#

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/spec_*.rb']
  t.verbose = true
end

#==================#
#===--- RDoc ---===#
#==================#

require 'rake/rdoctask'
Rake::RDocTask.new do |t|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  t.rdoc_dir = 'rdoc'
  t.title = "rulebook #{version}"
  t.rdoc_files.include('README*')
  t.rdoc_files.include('lib/**/*.rb')
end

#==================#
#===--- Reek ---===#
#==================#
begin
  require 'reek/rake/task'

  Reek::Rake::Task.new do |t|
      t.fail_on_error = true
      t.verbose = true
  end
rescue LoadError
  puts "Reek (or a dependency) not available. Install it with: gem install reek"
end

#=====================#
#===--- Jeweler ---===#
#=====================#

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rulebook"
    gem.summary = %Q{Allows you to define a set of 'rules' or dynamic methods to apply to a class}
    gem.description = %Q{Lets you define methods with regex for dynamic methods}
    gem.email = "c00lryguy@gmail.com"
    gem.homepage = "http://github.com/c00lryguy/rulebook"
    gem.authors = ["Ryan Lewis"]
    gem.add_development_dependency "rspec", ">= 1.0.0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end