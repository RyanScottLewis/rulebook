# rulebook

Allows you to define a set of 'rules' or dynamic methods to apply to a class

## Install

    > gem update --system
    > gem install rulebook

## How It Works

When you apply the `follows_rules` method to a class, it does three things:

* Creates the constant `RULEBOOK` in the class that contains a new RuleBook instance
* Extends the class with a `rule` method that allows you to define new rules to RULEBOOK. 
  This method takes one argument (must be Regexp) and a block which passes the Regexp's captures
* Overwrites the class's `method_missing?` method to try to match the currently called method against the rules in RULEBOOK.

## Simple Example

    require 'rulebook'
    
    class User
        follows_rules
        
        def initialize(name)
            @name = name
        end
        
        rule /say_(.+)/ do |what_to_say|
            puts what_to_say.gsub(/_/, ' ')
        end
    end
    
    User.new('Ryan').say_hello_world

## Better Example

    require 'rulebook'
    
    class User
        follows_rules
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

There are more examples in the examples and [test][1] directories.

[Rubular][2] if a great place to test your Regexp.

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