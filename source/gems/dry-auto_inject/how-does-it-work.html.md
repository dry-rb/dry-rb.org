---
title: How does it work?
layout: gem-single
---

dry-auto\_inject adds _constructor dependency injection_ to your objects. It achieves this by defining two methods in the module that you mix into your class.

First, it defines `.new`, which resolves dependencies from the container that you haven’t passed as explicit arguments. It then passes these arguments onto `#initialize`, as per Ruby’s usual behaviour.

It also defines `#initialize`, which receives these dependencies as arguments, and then assigns them to instance variables. These variables are made available via attr\_readers.

So when you specify dependencies like this:

```ruby
Import = Dry::AutoInject(MyContainer)

class MyClass
  include Import["users_repository"]
end
```

You’re building something like this (this isn’t a line-for-line copy of what is mixed into your class; it’s intended as a guide only):

```ruby
class MyClass
  attr_reader :users_repository

  def self.new(**args)
    deps = {
      users_repository: args[:users_repository] || MyContainer["users_repository"]
    }

    super(**deps)
  end

  def initialize(users_repository: nil)
    super()

    @users_repository = users_repository
  end
end
```

These methods are not defined directly on your class. They're defined in the module that you mix in, which mean you can also override them in your class if you wish to provide custom behavior.
