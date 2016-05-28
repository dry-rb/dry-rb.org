---
title: Type Constraints
layout: gem-single
---

Use `:type` key in a `param` or `option` declarations to set one of [dry types][dry-types] as a constraint.

```ruby
require 'dry-initializer'
require 'dry-types'

class User
  include Dry::Types.module
  extend  Dry::Initializer::Mixin

  param :name, type: Strict::String
end

user = User.new :Andrew # => #<TypeError ...>
```

Dry types can be used for value coercion:

```ruby
require 'dry-initializer'
require 'dry-types'

class User
  include Dry::Types.module
  extend  Dry::Initializer::Mixin

  param :name, type: Coercible::String
end

user = User.new :Andrew
user.name # => "Andrew"
```

There're many other ways to use dry types. See the [gem documentation][dry-types-docs] for further details.

### Types and Defaults

Type constraints are applied before assignment of default values. They do not check unassigned values.

That's why a default value bypasses the constraint.

```ruby
require 'dry-initializer'

class User
  include Dry::Types.module
  extend  Dry::Initializer::Mixin

  param :name, type: Strict::String.optional, default: -> { :Dude }
end

user = User.new :Dude  # fails the constraint with TypeError
user = User.new 'Dude' # passes the constraint
user = User.new        # constraint is not applied
user.name              # => :Dude (default value bypasses the constraint)
```

Both defaults and types (except for plain modules) are slow.
Their combination can make an initializer about 5 times as slow as a bare param/option declaration.

Do not use them without real necessity!

[dry-types]: https://github.com/dry-rb/dry-types
[dry-types-docs]: http://dry-rb.org/gems/dry-types/
