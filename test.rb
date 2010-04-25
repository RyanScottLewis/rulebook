class Rulebook  
    class Rule
        attr :what_to_capture, :block
        
        def initialize(what_to_capture, &block)
            raise(TypeError, 'what_to_capture must be of type Regexp') unless what_to_capture.is_a?(Regexp)
            
            @what_to_capture, @block = what_to_capture, block
        end
        
        def matches_against?(query)
            case @what_to_capture.class
                when Regexp
                    if match_against(query)
                        true
                    else
                        false
                    end
                    
                when String
                    # TODO
            end
        end
        
        def match_against(query)
            query.to_s.match(@what_to_capture)
        end
    end
end

class Rulebook
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


require 'pp'
class RuleBook
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

class Module
    def follows_rules
        const_set('RULEBOOK', Rulebook.new)
        extend RuleBook::ClassMethods
        include RuleBook::InstanceMethods
    end
end
#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I
#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S
#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T
#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N
#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T
#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E
#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G#T#E#S#T#I#N#G
class User
    follows_rules
    attr :nouns, :adjectives
    
    rule(/is_(.*)/) do |adjective|
        @adjectives ||= []
        @adjectives << adjective.gsub(/_/, ' ')
    end
    
    rule(/is_a_(.*)/) do |noun|
        @nouns ||= []
        @nouns << 'a ' + noun.gsub(/_/, ' ')
    end
end

ryguy = User.new

ryguy.is_awesome
ryguy.is_a_bear
ryguy.is_superfly
ryguy.is_a_programmer
ryguy.is_fantastic
ryguy.is_a_master_of_the_ancient_chinese_art_of_karate

puts "Ryguy is #{ryguy.adjectives.to_a.join(', ')}"
puts "Ryguy is #{ryguy.nouns.to_a.join(', ')}"