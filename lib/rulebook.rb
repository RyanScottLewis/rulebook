__DIR__ = File.dirname(__FILE__)
$:.unshift(__DIR__) unless $:.include?(__DIR__)

class Rulebook
  VERSION = "0.5.0"
  
  class Rule
    attr :block
    
    def initialize(regexp, &block)
      # TODO: Match more than Regexp. Strings and Symbols pls.
      raise(TypeError, 'regexp must be of type Regexp') unless regexp.is_a?(Regexp)
      raise(ArgumentError, 'a block is needed') unless block_given?
      @regexp, @block = regexp, block
    end
    
    def [](query)
      query.to_s.downcase.match(@regexp)
    end
    alias_method :match, :[]
    
    def matches?(query)
      !self[query].nil?
    end
  end
  
  attr_accessor :rules
  
  def initialize
    @rules = []
  end
  
  def add(regexp, &block)
    @rules << Rule.new(regexp, &block)
  end
  # alias_method :<<. :add
  
  def [](query)
    @rules.find_all { |rule| rule.matches?(query) }
  end
  alias_method :rules_that_match_against, :[]
  alias_method :match, :[]
end

require 'meta_tools'
# TODO: implement within meta_tools
module MetaTools
  def meta_class; metaclass; end
end

require 'core_ext'
