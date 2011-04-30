require 'helper'
require 'date'

class TestRule < Test::Unit::TestCase
  class User
    attr_accessor :name, :gender, :height, :eye_color, :date_of_birth, :age
  end


  class User
    def User.list
      @@list ||= []
    end
    
    def initialize
      User.list << self
    end
  end

  # Instance Rules
  class User
    rule(/is_your_name_([a-z_]+)\?/) do |name|
      @name.capitalize == name.capitalize
    end
    
    rules do
      rule(/is_(male|female)\?/) do |gender|
        @gender == gender.to_sym
      end
    end
  end

  User.rule(/was_born_([a-z]+_\d+(st|nd|rd|th)?_\d+)/) do |date_of_birth|
    @date_of_birth = Date.parse(date_of_birth.gsub(/_/, ' '))
    @age = (Date.today - @date_of_birth).to_i / 365
  end

  User.rules do
    rule(/is_(\d+)\?/) do |age|
      @age == age.to_i
    end
  end

  # Class Rules
  # TODO: two more
  class User
    class_rule(/new_(male|female)/) do |gender|
      instance = new
      instance.gender = gender.to_sym
      instance
    end
    
    class_rules do
      rule(/find_(males|females)/) do |gender|
        list.find_all { |user| user.gender == gender.to_sym }
      end
    end
  end


  context 'Ryan' do
    setup do
      @user = User.new_male
      @user.name = 'Ryan'
      @user.was_born_jan_15_1991
    end
    
    should 'answer yes to all obvious questions' do
      assert @user.is_your_name_ryan?
      assert @user.is_male?
      assert @user.is_19?
    end
    
    should 'answer no to all silly questions' do
      refute @user.is_your_name_mark?
      refute @user.is_female?
      refute @user.is_21?
    end
    
    teardown do
      @user = nil
    end
  end
  
  context 'User list' do
    should 'should have any females' do
      assert User.find_females.length == 0
    end
  end
end