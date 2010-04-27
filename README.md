# rulebook

Allows you to define a set of 'rules' or dynamic methods to apply to a class.

## Install

    > gem update --system
    > gem install rulebook

## _Notice_

The format has changed since version 0.1.1. Check out the example below:

## Simple Example

    require 'rulebook'
    
    class User
        def initialize(name)
            @name = name
        end
        
        rules do
            rule /say_(.+)/ do |what_to_say|
                puts "#{@name} says '#{what_to_say.gsub(/_/, ' ')}'"
            end
        end
    end
    
    User.new('Ryan').say_hello_world # => "Ryan says 'hello world'"

## How It Works

When you call the `rules` method in a class, it defines the constant `INSTANCE_RULEBOOK` and sets it to a new `RuleBook` instance; but only if the constant wasn't already defined. This way, it only defines the constant the first time you call the `rules` method.

When the first time `rules` is called in a class, we also include the `RuleBook::InstanceMethods` module which overrides the classes `method_missing`. So when you call an undefined method on your class's instance, we will try to match the method against the rules you've defined in `INSTANCE_RULEBOOK`.

There is also a method called `class_rules` which does the same as rules does, only it defines the `CLASS_RULEBOOK` constance in the class; which is a different `RuleBook` instance. The first time `class_rules` is called, it extends the class with the `RuleBook::ClassMethods` module, which also contains a `method_missing` method.

## Better Example

    require 'rulebook'
    
    class User
        attr :name, :title
        
        def initialize(name)
            @name = name
            @title = :user
        end
        
        rules do
            rule /is_(admin|moderator|super_user|user)/ do |title|
                @title = title.to_sym
            end
        end
    end
    
You can now do things like

    users = [
        User.new('Ryan'),
        User.new('Natale'),
        User.new('Joe'),
        User.new('Monica'),
        User.new('Matt'),
        User.new('Jess')
    ].shuffle
    
    users[0].is_admin
    users[1].is_moderator
    users[2].is_super_user
    
    users.each do |user|
        puts "#{user.name} is a #{user.title}"
    end

## Class Methods Example

    class Car
        attr :make, :model
        
        def initialize(make, model)
            @make, @model = make.capitalize, model.capitalize
        end
        
        class_rules do
            rule /new_([a-z]+)_(.+)/ do |make, model|
                new(make, model)
            end
        end
    end
    
    my_cars = [
        Car.new_honda_accord,
        Car.new_dodge_neon,
        Car.new_volkswagen_beetle
    ]
    
    my_cars.first.make # => "Honda"
    my_cars.first.model # => "Accord"

### Now lets add some instance rules

    class Car
        rules do
            rule /is_(.+)\?/ do |make_or_model|
                if @make == make_or_model || @model == make_or_model
                    true
                else
                    false
                end
            end
        end
    end
    
    my_cars.first.is_honda? # => true
    my_cars.first.is_beetle? # => false

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