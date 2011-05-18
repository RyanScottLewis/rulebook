require 'helper'

context "A rule all on it's lonesome" do
  setup do
    Rulebook::Rule.new(/is_lonely/) { "='(" }
  end
  asserts("that this rule truly is alone") { topic.matches_against?(:is_lonely) }
  denies("an awkward method") { topic.matches_against?(:is_surrounded_by_other_rule_friends) }
  asserts("this works with Strings") { topic.matches_against?("is_lonely") }
end