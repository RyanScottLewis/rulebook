$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'mocha'
require 'rulebook'

# Require all files within /support
Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }