require 'spec_helper'

class SomeService
  class << self
    follows_the_rules!
    
    rulebook.add(/^say_([a-zA-Z1-9_])S/) do |message|
      message.gsub(/_/, ' ')
    end
  end
end

describe SomeService do
  describe "When a method matches the rule's regexp" do
    it "should respond correctly" do
      SomeService.say_hello_world.should == "hello world"
    end
  end
end