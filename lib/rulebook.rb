class RuleBook
  # This class creates an instance of a Rule, which holds the
  # Regexp to match against and the block to run when matched
  class Rule
    attr :block
    
    def initialize(what_to_capture, &block)
      raise(TypeError, 'what_to_capture must be of type Regexp') unless what_to_capture.is_a?(Regexp)
      raise(ArgumentError, 'a block is needed') unless block_given?
      @what_to_capture, @block = what_to_capture, block
    end
    
    def [](query); query.to_s.downcase.match(@what_to_capture); end
    alias_method :match_against, :[]
    def matches_against?(query); !self[query].nil?; end
  end
end

class RuleBook
  attr_accessor :rules
  
  def initialize
    @rules = []
  end
  
  def rule(what_to_capture, &block)
    @rules.push( Rule.new(what_to_capture, &block) ).last
  end
  
  def rules_that_match_against(query)
    @rules.find_all { |rule| rule.matches_against?(query) }
  end
end

# TODO: DRY up the code here a bit...
class RuleBook
  module IncludeMethods
    def respond_to?(meth)
      rulebook = self.class.const_get('INSTANCE_RULEBOOK')
      rulebook.rules_that_match_against(meth).any? || super
    end 
    
    def method_missing(meth, *args, &block)
      rulebook = self.class.const_get('INSTANCE_RULEBOOK')
      rules = rulebook.rules_that_match_against(meth)
      
      # TODO: Why would this ever be nil?
      unless rules.nil? || rules.empty?
        # Run the first matched rule..
        # TODO: if the method NEXT if called within the rule, 
        #       then goto the next matched rule
        rule = rules.first 
        captures = rule[meth].captures || []
        block = rule.block
        
        # Remove the possibility of optional arguments
        arity = block.arity == -1 ? 0 : block.arity
        
        # Define the method
        klass = self.class
        klass.send(:define_method, meth) do |*args|
          instance_exec(*(captures + args).take(arity), &block)
        end 
        
        # Call the method
        send(meth, *args, &block)
      else
        super
      end
    end
  end
  
  module ExtendMethods
    def respond_to?(meth)
      rulebook = const_get('CLASS_NOTEBOOK')
      rulebook.rules_that_match_against(meth).any? || super
    end 
    
    def method_missing(meth, *args, &block)
      rulebook = const_get('CLASS_NOTEBOOK')
      rules = rulebook.rules_that_match_against(meth)
      
      # TODO: Why would this ever be nil?
      unless rules.nil? || rules.empty?
        # Run the first matched rule..
        # TODO: if the method NEXT if called within the rule, 
        #       then goto the next matched rule
        rule = rules.first 
        captures = rule[meth].captures || []
        block = rule.block
        
        # Remove the possibility of optional arguments
        arity = block.arity == -1 ? 0 : block.arity
        
        # Define the method
        klass = class << self; self; end
        klass.send(:define_method, meth) do |*args|
          class_exec(*(captures + args).take(arity), &block)
        end 
        
        # Call the method
        send(meth, *args, &block)
      else
        super
      end
    end
  end
end

# TODO: DRY up the code here too...
class Module
  def rule(what_to_capture, &block)
    raise(ArgumentError, 'rules must have a block') unless block_given?
    
    setup_rulebook('INSTANCE_RULEBOOK', :include)
    const_get('INSTANCE_RULEBOOK').rule(what_to_capture, &block)
  end
  
  def class_rule(what_to_capture, &block)
    raise(ArgumentError, 'class_rules must have a block') unless block_given?
    
    setup_rulebook('CLASS_NOTEBOOK', :extend)
    const_get('CLASS_NOTEBOOK').rule(what_to_capture, &block)
  end
  
  def rules(&block)
    raise(ArgumentError, 'rules must have a block') unless block_given?
    
    setup_rulebook('INSTANCE_RULEBOOK', :include)
    const_get('INSTANCE_RULEBOOK').instance_eval(&block)
    const_get('INSTANCE_RULEBOOK')
  end
  
  def class_rules(&block)
    raise(ArgumentError, 'class_rules must have a block') unless block_given?
    
    setup_rulebook('CLASS_NOTEBOOK', :extend)
    const_get('CLASS_NOTEBOOK').instance_eval(&block)
    const_get('CLASS_NOTEBOOK')
  end
  
  private
  
  def setup_rulebook(rulebook_constant, extend_or_include)
    raise(ArgumentError, 'extend_or_include must be :extend or :include') unless [:extend, :include].include?(extend_or_include)
    
    unless const_defined?(rulebook_constant)
      const_set(rulebook_constant, RuleBook.new)
      
      module_name = extend_or_include.to_s.capitalize + 'Methods'
      send(extend_or_include, RuleBook.const_get(module_name))
    end
  end
end