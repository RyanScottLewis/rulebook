class Rulebook
  # This class creates an instance of a Rule, which holds the
  # Regexp to match against and the block to run when matched
  class Rule
    attr :block
    
    def initialize(what_to_capture, &block)
      raise(TypeError, 'what_to_capture must be of type Regexp') unless what_to_capture.is_a?(Regexp)
      raise(ArgumentError, 'a block is needed') unless block_given?
      @what_to_capture, @block = what_to_capture, block
    end
    
    def [](query)
      # We have to check for start and end of string regexp..
      # We also have to check for strings and symbols and all of that jazz

      query.to_s.downcase.match(@what_to_capture)
    end
    alias_method :match_against, :[]
    def matches_against?(query); !self[query].nil?; end
  end
end