require 'helper'

class TestChevy < Test::Unit::TestCase
    class Engine
        follows_rules
        attr :state
        
        def initialize
            @state = "off"
        end
        
        rule(/is_(.*)/) do |state|
            @state = state.gsub(/_/, " ")
        end
    end

    context 'A Chevy engine checked with #state_is?' do
        setup do
            @chevy = Engine.new
            class << @chevy
                def state_is?(state)
                    @state == state
                end
            end
        end
        
        should 'be off' do
            assert @chevy.state_is?('off')
        end
        
        should 'be idling' do
            @chevy.is_idling
            assert @chevy.state_is?('idling')
        end
        
        should 'be broken as usual' do
            @chevy.is_broken_as_usual
            assert @chevy.state_is?('broken as usual')
        end
    end
    
    context 'A Chevy engine checked with custom rule' do
        setup do
            @chevy = Engine.new
            class << @chevy
                rule(/is_(.*)?/) do |state|
                    @state == state
                end
            end
        end
        
        should 'be off' do
            assert @chevy.is_off?
        end
        
        should 'be idling' do
            @chevy.is_idling
            assert @chevy.is_idling?
        end
        
        should 'be broken as usual' do
            @chevy.is_broken_as_usual
            assert @chevy.is_broken_as_usual?
        end
    end
end