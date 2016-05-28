---
title: Readers
layout: gem-single
---

By default `attr_reader` is defined for every param and option.

To skip it, use `reader: false`:

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer::Mixin

  param :name
  param :email, reader: false
end

user = User.new 'Luke', 'luke@example.com'
user.name  # => 'Luke'

user.email                         # => #<NoMethodError ...>
user.instance_variable_get :@email # => 'luke@example.com'
```

No writers are defined. Define them using pure ruby `attr_writer` when necessary.
