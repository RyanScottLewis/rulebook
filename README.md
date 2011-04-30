# rulebook ![](http://stillmaintained.com/c00lryguy/rulebook.png)

Allows you to define a set of 'rules' or dynamic methods to apply to a class.

## Install

    > gem update --system
    > gem install rulebook

## Simple Example

    require 'rulebook'
    
    class User
      follows_the_rules!

      def initialize(name)
        @name = name
      end
      
      rulebook.add /say_(.+)/ do |what_to_say|
        puts "#{@name} says '#{what_to_say.gsub(/_/, ' ')}'"
      end
    end
    
    User.new('Ryan').say_hello_world # => Ryan says 'hello world'

## How It Works

TODO

## Better Example

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
    
You can now do things like

    users = ['Ryan', 'Natale', 'Kasey', 'Jenna', 'Joe', 'Monica','Allan', 'Amanda']
    users.collect! { |n| User.new(n) }.shuffle!
    
    users[0].is_admin
    users[1].is_moderator
    users[2].is_super_user
    
    users.each do |user|
      puts "#{user.name} is a #{user.title}"
    end

## Class Methods Example

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

This works out if you already have ``

### Now lets add some instance rules

    class Car
        rule /is_(.+)\?/ do |make_or_model|
            make_or_model.capitalize!
            @make == make_or_model || @model == make_or_model
        end
    end

    p my_cars.first.is_honda? # => true
    p my_cars.first.is_beetle? # => false

## Using outside of class block

Since `rule` and `class_rule` are both class methods,
you can call them all outside of a class block:

    Car.rule(...){}
    Car.class_rule(...){}

Since 0.2 you can call the class methods `rules` and `class_rules` to wrap your rules in a block:

    Car.rules do
        rule(...){}
    end
    
    Car.class_rules do
        rule(...){}
    end
    
The result is exactly the same. These are also callable from inside the class.

    class Car
        rules do
            rule(...){}
        end
        class_rules do
            rule(...){}
        end
    end

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