$LOAD_PATH.unshift(File.dirname(__FILE__))

class Rulebook
  VERSION = "0.4.3"
end

class Rulebook
  
  class Rule
    attr :block
    
    def initialize(what_to_capture, &block)
      # TODO: Match more than Regexp. Strings and Symbols pls.
      raise(TypeError, 'what_to_capture must be of type Regexp') unless what_to_capture.is_a?(Regexp)
      raise(ArgumentError, 'a block is needed') unless block_given?
      @what_to_capture, @block = what_to_capture, block
    end
    
    def [](query)
      query.to_s.downcase.match(@what_to_capture)
    end
    alias_method :match_against, :[]
    alias_method :match, :[]
    
    def matches_against?(query)
      !self[query].nil?
    end
    alias_method :matches?, :matches_against?
  end
  
  attr_accessor :rules
  
  def initialize
    @rules = []
  end
  
  def add(what_to_capture, &block)
    @rules << Rule.new(what_to_capture, &block)
  end
  
  def [](query)
    @rules.find_all { |rule| rule.matches?(query) }
  end
  alias_method :rules_that_match_against, :[]
  alias_method :match, :[]
end

require 'rulebook/instance_methods'
require 'core_ext'