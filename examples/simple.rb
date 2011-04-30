$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'rulebook'

class User
  follows_the_rules!

  attr :title

  def initialize(title=:user)
    @title = title
  end

  rulebook.add /is_(admin|user)/ do |title|
    @title = title.to_sym
    self
  end

  rulebook.add /is_(admin|user)\?/ do |title|
    @title == title.to_sym
  end
end

u = User.new

p u.is_user?  # => true
p u.is_admin? # => false

u.is_admin

p u.is_user?  # => false
p u.is_admin? # => true