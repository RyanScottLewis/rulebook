require 'helper'

class TestRyguy < Test::Unit::TestCase
    class Ryguy
        attr :nouns, :adjectives
        
        rules do
            rule(/is_a_(.*)/) do |noun|
                @nouns ||= []
                @nouns << noun.gsub(/_/, ' ')
            end
            
            rule(/is_(.*)/) do |adjective|
                @adjectives ||= []
                @adjectives << adjective.gsub(/_/, ' ')
            end
        end
    end
    
    context 'Ryguy' do
        setup do
            @ryguy = Ryguy.new
            @ryguy.is_awesome
            @ryguy.is_a_bear
            @ryguy.is_superfly
            @ryguy.is_a_programmer
            @ryguy.is_fantastic
            @ryguy.is_a_master_of_the_ancient_chinese_art_of_karate
        end
        
        should 'be awesome, superfly, and fantastic' do
            assert_same_elements(
                ['awesome', 'superfly', 'fantastic'],
                @ryguy.adjectives
            )
        end
        
        should 'be a bear, a programmer, and a master of karate' do
            assert_same_elements(
                ['bear', 'programmer', 'master of the ancient chinese art of karate'],
                @ryguy.nouns
            )
        end
    end
end