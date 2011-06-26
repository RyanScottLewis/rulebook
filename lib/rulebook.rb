$LOAD_PATH.unshift(File.dirname(__FILE__))

class Rulebook
  VERSION = "0.4.3"
end

require 'rulebook/rule'

class Rulebook
  attr_accessor :rules
  def initialize; @rules = []; end
  def add(what_to_capture, &block); @rules << Rule.new(what_to_capture, &block); end
  def [](query); @rules.find_all { |rule| rule.matches_against?(query) }; end
  alias_method :rules_that_match_against, :[]
end

require 'rulebook/class_methods'
require 'rulebook/instance_methods'
require 'rulebook/core_ext/module'