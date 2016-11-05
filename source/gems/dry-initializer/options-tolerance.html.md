---
title: Tolerance to Unknown Options
layout: gem-single
---

By default the initializer is strict for params, expecting them to be defined explicitly.

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer::Mixin
end

user = User.new 'joe@example.com' # raises ArgumentError
```

Before you define an `option` (only `params`), the initializer doesn't accept any:

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer::Mixin

  param :name
end

user = User.new 'Joe', email: 'joe@example.com' # raises ArgumentError
```

When you define any `option` it will take an ignore any one that hasn't been defined:

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer::Mixin

  option :name
end

user = User.new name: 'Joe', email: 'joe@example.com'
user.name # => 'Joe'

# It ignores all unknown options
user.respond_to? :email # => false
```
