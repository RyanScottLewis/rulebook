require 'helper'

class TestClassMethods < Test::Unit::TestCase
  class Car
    attr_accessor :make, :model
    
    def initialize(make, model)
      @make, @model = make, model
    end
    
    class_rules do
      rule(/new_([a-z]+)_(.+)/) do |make, model|
        
        make.capitalize!
        model = model.split('_').inject(''){ |result, word|
          result << word.capitalize + ' '
        }.strip
        new(make, model)
      end
    end
  end
  
  should 'be a Ford F150' do
    @car = Car.new_ford_f150
    assert_equal @car.make, 'Ford'
    assert_equal @car.model, 'F150'
  end

  should 'be a Ford Mustang' do
    @car = Car.new_ford_mustang
    assert_equal @car.make, 'Ford'
    assert_equal @car.model, 'Mustang'
  end
  
  should 'be a Pontiac GTO' do
    @car = Car.new_pontiac_gto
    @car.model.upcase!
    assert_equal @car.make, 'Pontiac'
    assert_equal @car.model, 'GTO'
  end
  
  should 'be a Toyota Camry' do
    @car = Car.new_toyota_camry
    assert_equal @car.make, 'Toyota'
    assert_equal @car.model, 'Camry'
  end
  
  should 'be a Hyundai Santa Fe' do
    @car = Car.new_hyundai_santa_fe
    assert_equal @car.make, 'Hyundai'
    assert_equal 'Santa Fe', @car.model
  end
end
