---
title: Params and Options
layout: gem-single
---

Use `param` to define plain argument:

```ruby
require 'dry-initializer'

class User
  extend  Dry::Initializer::Mixin

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
  extend Dry::Initializer::Mixin

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
  extend Dry::Initializer::Mixin

  option :name, as: :username
end

user = User.new name: "Joe"
user.username                         # => "Joe"
user.instance_variable_get :@username # => "Joe"
user.instance_variable_get :@name     # => nil
user.respond_to? :name                # => false
```

All names should be unique:

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer::Mixin

  param  :name
  option :name # => raises #<SyntaxError ...>
end
```

Uniqueness is controlled separately for params, options, and ultimate attributes:

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer::Mixin

  param  :name
  option :name,  as: :username # its ok, no conflict occurs
  option :login, as: :name     # fails (conflicts to param `name`)
  option :name,  as: :alias    # fails (conflicts to option `name`)
end
```
