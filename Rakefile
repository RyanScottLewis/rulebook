require 'rubygems'

require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs.concat ['lib', 'test']
  t.pattern = 'test/**/test_*.rb'
  t.verbose = false
end
task :default => :test

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)