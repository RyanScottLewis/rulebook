require 'rubygems'

require 'bundler'
begin
  Bundler.setup(:default, :test)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'riot'

# Stupid non-colored Windows terminal
class Riot::IOReporter
  def red(msg);    msg; end
  def green(msg);  msg; end
  def yellow(msg); msg; end
end

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rulebook'