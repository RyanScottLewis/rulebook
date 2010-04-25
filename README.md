# rulebook

Allows you to define a set of 'rules' or dynamic methods to apply to a class

## Example

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

There are more examples in the example directory and easy to understand tests in the tests directory

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
