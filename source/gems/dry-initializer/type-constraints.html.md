---
title: Type Constraints
layout: gem-single
name: dry-initializer
---

Use `:type` key in a `param` or `option` declarations to set one of [dry types][dry-types] as a constraint.

```ruby
require 'dry-initializer'
require 'dry-types'

class User
  extend Dry::Initializer
  param :name, type: Dry::Types['strict.string']
end

user = User.new :Andrew # => #<TypeError ...>
```

Dry types can be used for value coercion:

```ruby
require 'dry-initializer'
require 'dry-types'

class User
  extend Dry::Initializer
  param :name, type: Dry::Types['coercible.string']
end

user = User.new :Andrew
user.name # => "Andrew"
```

Instead of `:type` option you can send a constraint/coercer as the second argument:

```ruby
require 'dry-initializer'
require 'dry-types'

class User
  extend Dry::Initializer
  param :name, Dry::Types['coercible.string']
end
```

There're many other ways to use dry types. See the [gem documentation][dry-types-docs] for further details.

Both defaults and types (except for plain modules) are slow.
Their combination can make an initializer about 5 times as slow as a bare param/option declaration.

Do not use them without real necessity!

[dry-types]: https://github.com/dry-rb/dry-types
[dry-types-docs]: http://dry-rb.org/gems/dry-types/
