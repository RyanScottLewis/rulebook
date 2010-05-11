require 'helper'

describe RuleBook do
  before do
    @rule_book = RuleBook.new
  end
  
  it 'initialized correctly' do
    @rule_book.rules.empty?.should == true
  end
  
  it 'should respond_to #rules_that_match_against' do
    @rule_book.respond_to?(:rules_that_match_against).should == true
  end
  
  context 'adding rules' do
    it 'creates a rule using #rule' do
      @rule_book.respond_to?(:rule).should == true
      
      @rule_book.rule(/is_(red|green|blue)/) {}
      
      @rule_book.rules_that_match_against(:is_red).length.should == 1
      @rule_book.rules_that_match_against(:is_green).length.should == 1
      @rule_book.rules_that_match_against(:is_blue).length.should == 1
      
      @rule_book.rules_that_match_against(:is_yellow).length.should == 0
      @rule_book.rules_that_match_against(:is_purple).length.should == 0
      @rule_book.rules_that_match_against(:is_brown).length.should == 0
    end
    
    it 'creates a rule using #rules' do
      @rule_book.should_receive(:rules)
      
      @rule_book.rules do
        rule(/is_(red|green|blue)/) {}
      end
      
      @rule_book.rules_that_match_against(:is_red).length.should == 1
      @rule_book.rules_that_match_against(:is_green).length.should == 1
      @rule_book.rules_that_match_against(:is_blue).length.should == 1
      
      @rule_book.rules_that_match_against(:is_yellow).length.should == 0
      @rule_book.rules_that_match_against(:is_purple).length.should == 0
      @rule_book.rules_that_match_against(:is_brown).length.should == 0
    end
  end

  # context "transfering money" do
    # it "deposits transfer amount to the other account" do
      # source = Account.new(50, :USD)
      # target = mock('target account')
      # target.should_receive(:deposit).with(Money.new(5, :USD))
      # source.transfer(5, :USD).to(target)
    # end

    # it "reduces its balance by the transfer amount" do
      # source = Account.new(50, :USD)
      # target = stub('target account')
      # source.transfer(5, :USD).to(target)
      # source.balance.should == Money.new(45, :USD)
    # end
  # end
end
