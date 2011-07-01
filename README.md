# rulebook ![](http://stillmaintained.com/c00lryguy/rulebook.png)

Allows you to define a set of 'rules' or dynamic methods to apply to a class.

## Install

    > gem update --system
    > gem install rulebook

## Simple Example

```ruby
require 'rulebook'

class User
  follows_the_rules!

  def initialize(name)
    @name = name
  end
  
  def_rule(/say_(.+)/) do |what_to_say|
    puts "#{@name} says '#{what_to_say.gsub(/_/, ' ')}'"
  end
end

User.new('Ryan').say_hello_world # => Ryan says 'hello world'
```

## Better Example

```ruby
require 'rulebook'

class User
  attr :name, :title
  
  def initialize(name)
    @name = name
    @title = :user
  end
  
  rulebook.add /is_(admin|moderator|super_user|user)/ do |title|
    @title = title.to_sym
  end
end
```

You can now do things like

```ruby
users = ['Ryan', 'Natale', 'Kasey', 'Jenna', 'Joe', 'Monica','Allan', 'Amanda']
users.collect! { |n| User.new(n) }.shuffle!

users[0].is_admin
users[1].is_moderator
users[2].is_super_user

users.each do |user|
  puts "#{user.name} is a #{user.title}"
end
```

## Class Methods Example

```ruby
require 'rulebook'

class Car
  attr :make, :model
  
  def initialize(make, model)
    @make, @model = make.capitalize, model.capitalize
  end
  
  class << self
    follows_the_rules!

    rulebook.add /new_([a-z]+)_(.+)/ do |make, model|
      new(make, model)
    end
  end
end

my_cars = [
  Car.new_honda_accord,
  Car.new_dodge_neon,
  Car.new_volkswagen_beetle
]

p my_cars.first.make # => "Honda"
p my_cars.first.model # => "Accord"
```

### Now lets add some instance rules

```ruby
class Car
  follows_the_rules!
  
  rulebook.add /is_(.+)\?/ do |make_or_model|
    make_or_model.capitalize!
    @make == make_or_model || @model == make_or_model
  end
end

p my_cars.first.is_honda? # => true
p my_cars.first.is_beetle? # => false
```

## Using outside of class block

Since `rulebook` is a class method, you can easily define rules outside 
of classes:

```ruby
Integer.follows_the_rules!
Integer.rulebook.add /to_base_(\d+)/ do |base|
  p base
  p "OMG"
  to_s(base)
end

p 10.to_base_16
```

#### There are more examples in the examples and [test][1] directories and [Rubular][2] is a great place to test your Regexp.

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Ryan Lewis. See LICENSE for details.


[1]: http://github.com/c00lryguy/rulebook/tree/master/test/
[2]: http://rubular.com/
