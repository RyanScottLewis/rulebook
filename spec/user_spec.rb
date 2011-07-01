require 'spec_helper'

describe User do
  describe ".new" do
    it "returns a new User with the role of :user" do
      User.new.instance_variable_get(:@role).should == :user
    end
  end
  describe ".new_user" do
    it "returns a new User with the role of :user" do
      User.new_user.instance_variable_get(:@role).should == :user
    end
  end
  describe ".new_moderator" do
    it "returns a new User with the role of :moderator" do
      User.new_moderator.instance_variable_get(:@role).should == :moderator
    end
  end
  describe ".new_admin" do
    it "returns a new User with the role of :admin" do
      User.new_admin.instance_variable_get(:@role).should == :admin
    end
  end
  describe "#is_user?" do
    describe "when the user's role is :user" do
      it "should return true" do
        User.new.is_user?.should == true
      end
    end
    describe "when the user's role is not :user" do
      it "should return false" do
        User.new_moderator.is_user?.should == false
        User.new_admin.is_user?.should == false
      end
    end
  end
  describe "#is_moderator?" do
    describe "when the user's role is :moderator" do
      it "should return true" do
        User.new_moderator.is_moderator?.should == true
      end
    end
    describe "when the user's role is not :moderator" do
      it "should return false" do
        User.new.is_moderator?.should == false
        User.new_user.is_moderator?.should == false
        User.new_admin.is_moderator?.should == false
      end
    end
  end
  describe "#is_admin?" do
    describe "when the user's role is :admin" do
      it "should return true" do
        User.new_admin.is_admin?.should == true
      end
    end
    describe "when the user's role is not :admin" do
      it "should return false" do
        User.new.is_admin?.should == false
        User.new_user.is_admin?.should == false
        User.new_moderator.is_admin?.should == false
      end
    end
  end
end