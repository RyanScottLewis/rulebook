require 'spec_helper'

Integer.follows_the_rules!
Integer.def_rule /^to_base_(\d+)$/ do |base|
  to_s(base)
end

describe Integer do
  describe "#to_base_2" do
    it "should return the equivalent binary string" do
      0.to_base_2.should == "0"
      1.to_base_2.should == "1"
      2.to_base_2.should == "10"
      3.to_base_2.should == "11"
      4.to_base_2.should == "100"
    end
  end
end