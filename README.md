rulebook ![](http://stillmaintained.com/c00lryguy/rulebook.png)
===============================================================

Allows you to define a set of 'rules' or dynamic methods to apply to a class.

Install
-------

    > gem update --system
    > gem install rulebook

Simple Example
--------------

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

Rulebook::Rule
--------------

An instance of `Rulebook::Rule` simply holds two attributes, `@regexp` and `@block`:


```ruby
rule = Rulebook::Rule.new(/^regexp$/) { puts "Hello" } # => #<Rule:0x0000>
rule.regexp # => /^regexp$/
rule.block  # => #<Proc:0x0000>
```

It's a simple as that.  
There are a couple of helper methods as well:

```ruby
rule.match('regexp') # => #<MatchData "regexp">
rule['regexp'] # => #<MatchData "regexp">
rule.matches?('regexp') # => true
```

Rulebook
--------

An instance of `Rulebook` holds a single attribute, `@rules`, which is a simple `Array` of `Rulebook::Rule` instances:

```ruby
rulebook = Rulebook.new
rule = Rulebook::Rule.new(/^regexp$/) { "Hello" }

rulebook.rules << rule
rulebook.rules # => [#<Rule:0x0000>]
```

`Rulebook` also contains a few helper methods:

```ruby
rulebook.add(/testing/) { "testing" }
rulebook.rules # => [#<Rule:0x0000>, #<Rule:0x0eb6>]

rulebook.rules_that_match_against("testing") # => [#<Rule:0x0eb6>]
rulebook.match("testing") # => [#<Rule:0x0eb6>]
rulebook["testing"] # => [#<Rule:0x0eb6>]
```

follows_the_rules!
------------------

When you `require 'rulebook'`, we automatically define a method within `Module`
named `follows_the_rules!`.  
This defines two new class methods; `def_rule` and `def_class_rule`.

```ruby
class User
end

p User.methods.grep(/follows|def_/) # => ["follows_the_rules!"]

class User
  follows_the_rules!
end

p User.methods.grep(/follows|def_/) # => ["follows_the_rules!", "def_rule", "def_class_rule"]
```

This is to ensures that only the Objects that you _want_ to follow rules will have these methods available.  
You may call `follows_the_rules!` Outside of the class as well:

```ruby
class User
end

User.follows_the_rules!

p User.methods.grep(/follows|def_/) # => ["follows_the_rules!", "def_rule", "def_class_rule"]
```

def_rule
--------

When you define a rule on a class using `def_rule` the first time, we will add an instance variable to the class 
named `@rulebook` that contains an instance of `Rulebook`. We then define the rule within that rulebook instance.

Now, when you call a method that does not yet exist in your class, we check the rulebook to see if the method called
matches any of the defined rules.

If it doesn't we just go ahead and let `method_missing` do it's thing (A.K.A. throw a `NoMethodError`), otherwise
we find the first rule that matches the method, take the block associated with that rule and _define_ the 
method. The next step is to simply _call_ the method.

Take the following for example (although a bit useless, it describes the usage pretty clearly):

```ruby
class User
  follows_the_rules!
  
  def_rule(/foo(?:bar)?/) { "FOOBAR!" }
end

user = User.new
p user.methods - Object.new.methods # => []
```
    
As you can see, no instance methods are defined within the `User` object.  
So when I call a method that matches the `Regexp` within the defined rule,
it will actually define the instance method on the `User` object:

```ruby
p user.foo # => "FOOBAR"
p user.methods - Object.new.methods # => [:foo]
p user.foobar # => "FOOBAR"
p user.methods - Object.new.methods # => [:foo, :foobar]
```

def_class_rule
--------------

`def_class_rule` works in much the same way as `def_rule`, except on the class.  
Here's a small example if `def_class_rule` in action:

```ruby
class User
  follows_the_rules!
  attr :role
  
  def_class_rule(/new_(admin|moderator)/) do |role|
    instance = new
    instance.role = role.to_sym
    instance
  end
  
  def initialize
    @role = user
  end
  
  def role=(new_role)
    @role = new_role.to_sym
  end
end

User.new.role # => :user
User.new_moderator.role # => :moderator
User.new_admin.role # => :admin
```

Captures
--------

As seen in the last example, when using `def_rule` or `def_class_rule`, you can pass 
the captures from the match to the block given.  
Here is a nice example of that
usage:

```ruby
class User
  follows_the_rules!
  
  def_class_rule(/new_(admin|moderator|user)/) do |role|
    new.instance_eval { @role = role.to_sym; self }
  end
  
  def_rule(/is_(admin|moderator|user)\?/) do |role|
    @role == role.to_sym
  end
  
  def initialize
    @role = :user # default
  end
end

user = User.new_admin
user.is_user? # => false
user.is_admin? # => true
```
    
Arguments
---------

If you would like to add arguments to the rule, simply tack them on the end
of the block arguments. Just like you would `define_method`:

```ruby
class Book
  def_rule(/^page_(\d+)$/) do |page_number, line_number=1|
    puts "This is the contents of page #{page_number}, line #{line_number}."
  end
end

book = Book.new
book.page_15 # => This is the contents of page 15, line 1.
book.page_15(3) # => This is the contents of page 15, line 3.
```

Method Missing
--------------

Don't use it.  
Say you have the following class:

```ruby
class Foo
  def bar
    "foobar"
  end
  def baz(str_to_append="!!!")
    "foobaz#{str_to_append}"
  end
end
```

And another class that wants to delegate missing methods to an instance of `Foo`:

```ruby
class DelegateMeToFoo
  def initialize
    @foo = Foo.new
  end
  
  def method_missing(meth, *args, &blk)
    @foo.send(meth, *args, &blk)
  end
end

dmtf = DelegateMeToFoo.new
p dmtf.bar # => "foobar"
p dmtf.baz("??") # => "foobaz??"
```

This could easily be converted to use `Rulebook`:

```ruby
class DelegateMeToFoo
  def initialize
    @foo = Foo.new
  end
  
  def_rule(/(.*)/) do |meth, *args, &blk|
    @foo.send(meth, *args, &blk)
  end
end

dmtf = DelegateMeToFoo.new
p dmtf.bar # => "foobar"
p dmtf.baz("??") # => "foobaz??"
```

The advantages of doing so aren't apparent at first, but you must
realize that every single method (in this case, since no instance methods
are defined within `Foo`) that is sent to your `Foo` instance must
check all of it's defined methods for the method you are calling.
When it isn't found, it goes to the parent class to see if the instance
method is defined there. It continues up the chain in that fashion 
until it hits the top-level class. It then loops back around to 
your `Foo` instance to check for `method_missing` which is defined
in the example above. Since it found `method_missing`, it calls it.

Ruby must do this every single time.

With `Rulebook`, when you call `dmtf.bar` the first time, we actually
define the `bar` method on your `DelegateMeToFoo` instance, _then_ calls it.  
Now the next time `dmtf.bar` is called, it no longer has to do the 
`method_missing` dance and search the inheritance chain for the 
`bar` method. Ruby finds the newly defined method and runs it.

Note on Patches/Pull Requests
-----------------------------
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright (c) 2010-2011 Ryan Lewis. See LICENSE for details.

[1]: http://github.com/c00lryguy/rulebook/tree/master/test/
[2]: http://rubular.com/