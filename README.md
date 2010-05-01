# rulebook

Allows you to define a set of 'rules' or dynamic methods to apply to a class.

## Install

    > gem update --system
    > gem install rulebook

## _Notice_

The format is _back_ to what it was before 0.2.2!

## Simple Example

    require 'rulebook'
    
    class User
        def initialize(name)
            @name = name
        end
        
        rule /say_(.+)/ do |what_to_say|
            puts "#{@name} says '#{what_to_say.gsub(/_/, ' ')}'"
        end
    end
    
    User.new('Ryan').say_hello_world # => Ryan says 'hello world'

## How It Works

When you call the `rule` method in a class, it defines the constant `INSTANCE_RULEBOOK` and sets it to a new `RuleBook` instance; but only if the constant wasn't already defined. This way, it only defines the constant the first time you call the `rule` method.

When the first time `rule` is called in a class, we also include the `RuleBook::IncludeMethods` module which overrides the classes `method_missing`. So when you call an undefined method on your class's instance, we will try to match the method against the rules you've defined in `INSTANCE_RULEBOOK`.

There is also a method called `class_rule` which does the same as rules does, only it defines the `CLASS_RULEBOOK` constance in the class; which is a different `RuleBook` instance. The first time `class_rules` is called, it extends the class with the `RuleBook::ExtendMethods` module, which also contains a `method_missing` method.

## Better Example

    require 'rulebook'
    
    class User
        attr :name, :title
        
        def initialize(name)
            @name = name
            @title = :user
        end
        
        rule /is_(admin|moderator|super_user|user)/ do |title|
            @title = title.to_sym
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

    require 'rulebook'
    
    class Car
        attr :make, :model
        
        def initialize(make, model)
            @make, @model = make.capitalize, model.capitalize
        end
        
        class_rule /new_([a-z]+)_(.+)/ do |make, model|
            new(make, model)
        end
    end
    
    my_cars = [
        Car.new_honda_accord,
        Car.new_dodge_neon,
        Car.new_volkswagen_beetle
    ]
    
    p my_cars.first.make # => "Honda"
    p my_cars.first.model # => "Accord"

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