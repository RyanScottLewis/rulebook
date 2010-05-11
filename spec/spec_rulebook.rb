require 'helper'

class RuleBook  
  class Rule
    attr :block
    
    def initialize(what_to_capture, &block)
      raise(TypeError, 'what_to_capture must be of type Regexp') unless what_to_capture.is_a?(Regexp)
      @what_to_capture, @block = what_to_capture, block
    end
    
    def [](query)
      query.to_s.match(@what_to_capture)
    end
    alias_method :match_against, :[]
    
    def matches_against?(query)
      !self[query].nil?
    end
  end
end

class RuleBook
  attr_accessor :rules
  
  def initialize
    @rules = []
  end
  
  def rule(what_to_capture, &block)
    rule = Rule.new(what_to_capture, &block)
    @rules << rule
    rule
  end
  
  def rules_that_match_against(regexp)
    @rules.find_all { |rule| rule.matches_against?(regexp) }
  end
end

describe RuleBook do
  it 'initialized correctly' do
    rule_book = Rulebook.new
    rule_book.rules.empty?.should == true
  end
  
  context 'adding rules' do
    rule_book = Rulebook.new
    MyModel.should_receive(:find).with(id).and_return(@mock_model_instance)

  end

  context "transfering money" do
    it "deposits transfer amount to the other account" do
      source = Account.new(50, :USD)
      target = mock('target account')
      target.should_receive(:deposit).with(Money.new(5, :USD))
      source.transfer(5, :USD).to(target)
    end

    it "reduces its balance by the transfer amount" do
      source = Account.new(50, :USD)
      target = stub('target account')
      source.transfer(5, :USD).to(target)
      source.balance.should == Money.new(45, :USD)
    end
  end
end
