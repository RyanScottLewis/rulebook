require 'helper'

context "A rule all on it's lonesome" do
  setup do
    Rulebook::Rule.new(/is_lonely/) { "='(" }
  end
  asserts("matches correctly") { topic.matches_against?("is_lonely") }
end