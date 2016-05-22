---
title: Tolerance to Unknown Options
layout: gem-single
---

By default the initializer is strict - it expects params and options to be defined explicitly.

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer
end

user = User.new email: 'joe@example.com' # raises ArgumentError
```

Use `tolerant_to_unknown_options` helper to change this behavior and ignore undefined options:

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer

  tolerant_to_unknown_options
end

user = User.new email: 'joe@example.com'
# => <User >

# It ignores all unknown options
user.respond_to? :email # => false
```

Use `intolerant_to_unknown_options` to return to strict behaviour in a subclass.

```ruby
class Customer < User
  intolerant_to_unknown_options
end

User.new email: 'joe@example.com'     # => passes
Customer.new email: 'joe@example.com' # => raises ArgumentError
```

Be careful with this method because it breaks the [Liskov Substitution Principle][liskov-principle].

[liskov-principle]: https://en.wikipedia.org/wiki/Liskov_substitution_principle
