---
title: Type Constraints
layout: gem-single
---


To set type constraint use `:type` key:

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

You can use either plain Ruby classes and modules, or [dry-types][dry-types]:

```ruby
require 'dry-initializer'
require 'dry-types'

class User
  extend Dry::Initializer

  param :name,  type: String
  param :email, type: Dry::Types::Coercion::String
end

user = User.new name: :Andrew, email: 123 # => #<TypeError ...>
```

Alternatively you can define custom constraint as a proc or lambda with one argument at least:

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer

  param :name, type: ->(v, *) { raise TypeError if String === v }
end

user = User.new name: 'Andrew'
# => #<TypeError ...>
```

[dry-types]: https://github.com/dryrb/dry-types
