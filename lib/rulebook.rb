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
    
    def add_rule(what_to_capture, &block)
        @rules << Rule.new(what_to_capture, &block)
    end
    
    def find_rules_that_match_against(query)
        @rules.find_all { |rule| !query.to_s.match(rule.what_to_capture).nil? }
    end
end

class RuleBook
    # Provides the ClassMethods and InstanceMethods modules that get mixed into
    # the class that #follows_rules is called in
    module Mixin
        module ClassMethods
            def rule(what_to_capture, &block)
                rulebook = const_get('RULEBOOK')
                rulebook.add_rule(what_to_capture, &block)
            end
        end
        
        module InstanceMethods
            def method_missing(meth, *args, &blk)
                rulebook = self.class.const_get('RULEBOOK')
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
    end
end

class Module
    # Mixes in RuleBook::Mixin::ClassMethods and RuleBook::Mixin::InstanceMethods
    # TODO: allow argument to use other RuleBook instances.. also multiple rulebooks
    def follows_rules
        const_set('RULEBOOK', RuleBook.new)
        extend RuleBook::Mixin::ClassMethods
        include RuleBook::Mixin::InstanceMethods
    end
end