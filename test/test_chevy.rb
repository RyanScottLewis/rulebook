require 'helper'

class Engine
  attr_accessor :state
  
  def initialize
    @state = :off
  end

  rule(/is_(off|idle|broken)/) do |state|
    @state = state.to_sym
    self
  end

  rule(/is_(off|idle|broken)\?/) do |state|
    @state == state.to_sym
  end
end

context "A Chevy engine" do
  setup { Engine.new }

  context "that is off" do
    asserts_topic.assigns(:state, :off)
    asserts(:state).equals(:off)
  end

  context "that is idle" do
    setup { topic.is_idle }
    asserts_topic.assigns(:state, :idle)
    asserts(:state).equals(:idle)
  end

  context "that is broken as usual" do
    setup { topic.is_broken }
    asserts_topic.assigns(:state, :broken)
  end

  context "checked with custom rule" do
    context "that is off" do
      asserts(:is_off?)
    end

    context "that is idle" do
      setup { topic.is_idle }
      asserts(:is_idle?)
    end

    context "that is broken as usual" do
      setup { topic.is_broken }
      asserts(:is_broken?)
    end
  end
end 
