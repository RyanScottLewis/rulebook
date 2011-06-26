require 'helper'

module SomeService
  class << self
    follows_the_rules!
    
    rulebook.add(/^say_([a-zA-Z1-9_])S/) do |message|
      puts message.gsub(/_/, ' ')
    end
  end
end

context "A module with a class rulebook" do
  setup { SomeService }
  
  asserts("that a simple rule works correctly") {
    topic.say_hello_world
  }.equals?("hello world")
end