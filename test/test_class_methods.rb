require 'helper'

class TestChevy < Test::Unit::TestCase
    class Car
        class << self
            follows_rules
            
            rule(/new_(.+)_(.+)/) do |make, model|
                make.capitalize!
                model.capitalize!
                new(make, model)
            end
        end
        
        def initialize(make, model)
            @make, @model = make, model
        end
    end

    should 'be a Ford F150' do
        car = Car.new_ford_f150
        assert @chevy.state_is?('off')
    end

    should 'be a Ford Mustang' do
        car = Car.new_ford_f150
        assert @chevy.state_is?('off')
    end
end