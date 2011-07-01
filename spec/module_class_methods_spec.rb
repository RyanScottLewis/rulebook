require 'spec_helper'

module SomeService
  follows_the_rules!
  
  def_class_rule(/^say_([a-z_]+)$/) do |message|
    message.gsub(/_/, ' ')
  end
end

describe SomeService do
  describe "When a method matches the rule's regexp" do
    it "should respond correctly" do
      SomeService.say_hello_world.should == "hello world"
    end
  end
end