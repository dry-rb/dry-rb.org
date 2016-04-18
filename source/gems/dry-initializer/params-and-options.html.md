---
title: Params and Options
layout: gem-single
---

Use `param` to define plain argument:

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer

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

All names should be unique:

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer

  param  :name
  option :name # => raises #<SyntaxError ...>
end
```
