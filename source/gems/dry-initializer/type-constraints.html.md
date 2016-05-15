---
title: Type Constraints
layout: gem-single
---

Use `:type` key in a `param` or `option` declarations to set a constraint.

### Plain Ruby Module (Class)

You can constraint value by plain Ruby module/class.

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer

  param :name, type: String
end

user = User.new 'Andrew'
user.name # => 'Andrew'

user = User.new :andrew
# => #<TypeError ...>
```

### Dry::Types

Instead of module/class you can set one of [dry types][dry-types] as a constraint.

```ruby
require 'dry-initializer'
require 'dry-types'

module Types
  include Dry::Types.module
end

class User
  include Dry::Types.module
  extend  Dry::Initializer

  param :name, type: Strict::String
end

user = User.new name: :Andrew # => #<TypeError ...>
```

Dry types can be used for value coercion:

```ruby
require 'dry-initializer'
require 'dry-types'

class User
  include Dry::Types.module
  extend  Dry::Initializer

  param :name, type: Coercible::String
end

user = User.new name: :Andrew
user.name # => "Andrew"
```

There're many other ways to use dry types. See the [gem documentation][dry-types-docs] for further details.

### Case Equality

Any object can be set as a constraint via [Ruby case equality method `===`][case-equality]:

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer

  param :name, type: /^J/ # checks assigned value via `/^J/ === value`
end

user = User.new name: 'Andrew' # => #<TypeError ...>
user = User.new name: 'John'   # passes a constraint
```

While this method uses the same mechanizm, it is slower than constraint by a module.

### Types and Defaults

Type constraint are applied before assigning defaults. That's why default value can break the constraint.

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer

  param :name, type: /^J/, default: -> { 'Dude' }
end

User.new name: 'Andrew' # fails with TypeError
User.new name: 'John'   # passes
user = User.new         # passes as well
user.name # => 'Dude' (breaks the constraint)
```

Both defaults and types (except for plain modules) are quite slow.
Their combination can make the initializer as much as 5 times slower that a bare param/option declaration.

Do not use them without real necessity!

[dry-types]: https://github.com/dry-rb/dry-types
[dry-types-docs]: http://dry-rb.org/gems/dry-types/
[case-equality]: http://ruby-doc.org/core-2.3.1/Object.html#method-i-3D-3D-3D
