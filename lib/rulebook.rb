class RuleBook  
    class Rule
        attr :what_to_capture, :block
        
        def initialize(what_to_capture, &block)
            raise(TypeError, 'what_to_capture must be of type Regexp') unless what_to_capture.is_a?(Regexp)
            @what_to_capture, @block = what_to_capture, block
        end
        
        def matches_against?(query)
            !match_against(query).nil?
        end
        
        def match_against(query)
            query.to_s.match(@what_to_capture)
        end
    end
end

class RuleBook
    attr :rules
    
    def initialize
        @rules = []
    end
    
    def rule(what_to_capture, &block)
        rule = Rule.new(what_to_capture, &block)
        @rules << rule
        rule
    end
    
    def find_rules_that_match_against(query)
        @rules.find_all { |rule| !query.to_s.match(rule.what_to_capture).nil? }
    end
end

class RuleBook
    module InstanceMethods
        def method_missing(meth, *args, &blk)
            rulebook = self.class.const_get('INSTANCE_RULEBOOK')
            rules = rulebook.find_rules_that_match_against(meth)
            
            unless rules.nil?
                rules.first.tap do |rule|
                    match = rule.match_against(meth)
                    instance_exec(*match.captures, *args, &rule.block)
                end 
            else
                super
            end
        end

    end
    module ClassMethods
        def method_missing(meth, *args, &blk)
            rulebook = const_get('CLASS_NOTEBOOK')
            rules = rulebook.find_rules_that_match_against(meth)
            
            unless rules.nil?
                rules.first.tap do |rule|
                    match = rule.match_against(meth)
                    class_exec(*match.captures, *args, &rule.block)
                end 
            else
                super
            end
        end
    end
end

class Module
    def rules(&blk)
        unless const_defined('INSTANCE_RULEBOOK') do
            const_set('INSTANCE_RULEBOOK', RuleBook.new)
            include RuleBook::InstanceMethods
        end
        
        const_get('INSTANCE_RULEBOOK').instance_eval(&blk)
    end
    
    def class_rules(&blk)
        unless const_defined('CLASS_NOTEBOOK') do
            const_set('CLASS_NOTEBOOK', RuleBook.new)
            include RuleBook::ClassMethods
        end
        
        const_get('CLASS_NOTEBOOK').instance_eval(&blk)
    end
end