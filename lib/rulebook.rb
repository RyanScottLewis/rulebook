class RuleBook  
    class Rule
        attr :what_to_capture, :block
        
        def initialize(what_to_capture, &block)
            raise(TypeError, 'what_to_capture must be of type Regexp') \
                unless what_to_capture.is_a?(Regexp)
                
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
    module IncludeMethods
        def method_missing(meth, *args, &block)
            rulebook = self.class.const_get('INSTANCE_RULEBOOK')
            rules = rulebook.find_rules_that_match_against(meth)
            
            unless rules.nil? || rules.empty?
                rule = rules.first
                match = rule.match_against(meth)
                instance_exec(*match.captures, *args, &rule.block)
            else
                super
            end
        end
    end
    
    module ExtendMethods
        def method_missing(meth, *args, &block)
            rulebook = const_get('CLASS_NOTEBOOK')
            rules = rulebook.find_rules_that_match_against(meth)
            
            unless rules.nil?
                rule = rules.first
                match = rule.match_against(meth)
                class_exec(*match.captures, *args, &rule.block)
            else
                super
            end
        end
    end
end

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
        raise(ArgumentError, 'extend_or_include must be :extend or :include') \
            unless [:extend, :include].include?(extend_or_include)
            
        unless const_defined?(rulebook_constant)
            const_set(rulebook_constant, RuleBook.new)
            
            module_name = extend_or_include.to_s.capitalize + 'Methods'
            send(extend_or_include, RuleBook.const_get(module_name))
        end
    end
end