---
title: Type Constraints
layout: gem-single
name: dry-initializer
---

Use `:type` key in a `param` or `option` declarations to add type coercer.

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer
  param :name, type: proc(&:to_s)
end

user = User.new :Andrew # => #<TypeError ...>
```

Any object that responds to `#call` with 1 argument can be used as a type. Common examples are `proc(&:to_s)` for strings, `method(:Array)` (for arrays) or `Array.method(:wrap)` in Rails, `->(v) { !!v }` (for booleans), etc.

Another important example is the usage of `dry-types` as type constraints:

```ruby
require 'dry-initializer'
require 'dry-types'

class User
  extend Dry::Initializer
  param :name, type: Dry::Types['strict.string']
end

user = User.new :Andrew # => #<TypeError ...>
```

Instead of `:type` option you can send a constraint/coercer as the second argument:

```ruby
require 'dry-initializer'
require 'dry-types'

class User
  extend Dry::Initializer
  param :name,  Dry::Types['coercible.string']
  param :email, proc(&:to_s)
end
```

[dry-types]: https://github.com/dry-rb/dry-types
[dry-types-docs]: http://dry-rb.org/gems/dry-types/
