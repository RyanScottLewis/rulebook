require 'helper'
require 'date'

class TestUser < Test::Unit::TestCase
    class User
        follows_rules
        attr :gender, :height, :eye_color, :date_of_birth, :age
        
        rule(/is_(male|female)/) do |gender|
            @gender = gender.to_sym
        end
        
        rule(/is_(\d+)_foot_(\d+)(_inches)?/) do |feet, inches|
            @height = "#{feet}-#{inches}"
        end
        
        rule(/has_(amber|blue|brown|gray|grey|green|hazel|red)_eyes/) do |eye_color|
            @eye_color = eye_color.to_sym
        end
        
        rule(/was_born_([a-z]+_\d+(st|nd|rd|th)_\d+)/) do |date_of_birth|
            @date_of_birth = Date.parse(date_of_birth.gsub(/_/, ' '))
            @age = (Date.today - @date_of_birth).to_i / 365
        end
    end
    
    context 'A User instance' do
        setup do
            @ryguy = User.new
            @ryguy.is_male
            @ryguy.is_5_foot_8
            @ryguy.has_brown_eyes
            @ryguy.was_born_january_15th_1991
        end
        
        should 'be valid' do
            assert_equal :male, @ryguy.gender
            assert_equal '5-8', @ryguy.height
            assert_equal :brown, @ryguy.eye_color
            assert_equal Date.parse('January 15th, 1991'), @ryguy.date_of_birth
            assert_equal 19, @ryguy.age
        end
    end
end