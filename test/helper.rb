require 'rubygems'

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