---
title: Params and Options
layout: gem-single
---

Use `param` to define plain argument:

```ruby
require 'dry-initializer'

class User
  extend  Dry::Initializer

  param :name
  param :email
end

user = User.new 'Andrew', 'andrew@email.com'
user.name  # => 'Andrew'
user.email # => 'andrew@email.com'
```

Use `option` to define named (hash) argument:

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer

  option :name
  option :email
end

user = User.new email: 'andrew@email.com', name: 'Andrew'
user.name  # => 'Andrew'
user.email # => 'andrew@email.com'
```

Options can be renamed using `:as` key:

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer

  option :name, as: :username
end

user = User.new name: "Joe"
user.username                         # => "Joe"
user.instance_variable_get :@username # => "Joe"
user.instance_variable_get :@name     # => nil
user.respond_to? :name                # => false
```

You can also define several ways of initializing the same argument via different options:

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer

  option :phone
  option :telephone, as: :phone
  option :name, optional: true
end

User.new(phone: '1234567890').phone     # => '1234567890'
User.new(telephone: '1234567890').phone # => '1234567890'
```

Under the hood the initializer also sets the `@__options__` hash. It has no reader; you should provide it by youself when necessary.

The hash collects coerced values with defaults under the keys of attributes (renamed). Undefined values are skipped, so in the last example it would contain:

```ruby
user = User.new(telephone: '1234567890')

user.instance_variable_get(:@__options__)
# => { phone: '1234567890' }
```

Params are not included, only options are.
