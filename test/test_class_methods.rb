require 'helper'

class TestChevy < Test::Unit::TestCase
    class Car
        class << self
            follows_rules
            
            rule(/new_([a-z]+)_(.+)/) do |make, model|
                make.capitalize!
                model.capitalize!
                model.gsub!(/_/, ' ')
                new(make, model)
            end
        end
        
        def initialize(make, model)
            @make, @model = make, model
        end
    end

    should 'be a Ford F150' do
    end

    should 'be a Ford Mustang' do
    end
    
    should 'be a Pontiac GTO' do
    end
    
    should 'be a Toyota Camry' do
    end
    
    should 'be a Hyundai Santa Fe' do
    end
end