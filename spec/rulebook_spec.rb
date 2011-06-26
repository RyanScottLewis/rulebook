require 'spec_helper'

describe Rulebook do
  let(:rulebook) { Rulebook.new }
  let(:regexp) { /^foobar$/ }
  
  describe "#initialize" do
    it "should have the #rules method available" do
      rulebook.should be_instance_of(Rulebook)
      rulebook.should respond_to(:rules)
      rulebook.rules.should == Array.new
    end
  end
  
  describe "#add and #<<" do
    it "should add a rule correctly" do
      block = proc { puts "Foobar" }
      
      Rulebook::Rule.expects(:initialize).with(regexp, block)
      
      rulebook.rules.length.should == 0
      rulebook.add(regexp, &block)
      rulebook.rules.length.should == 1
    end
  end
  
  describe "#[], #match, and #rules_that_match_against" do
    it "should return an Array of rules that match the given query" do
      query = "foobar"
      
      rulebook.add(regexp) { "Foobar" }
      
      rulebook[query].should == [rulebook.rules.first]
      rulebook.match(query).should == [rulebook.rules.first]
      rulebook.rules_that_match_against(query).should == [rulebook.rules.first]
    end
  end
end