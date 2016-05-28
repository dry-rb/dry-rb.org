---
title: Default Values
layout: gem-single
---

By default both params and options are mandatory. Use `:default` key to make them optional:

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer::Mixin

  param  :name,  default: proc { 'Unknown user' }
  option :email, default: proc { 'unknown@example.com' }
end

user = User.new
user.name  # => 'Unknown user'
user.email # => 'unknown@example.com'

user = User.new 'Vladimir', email: 'vladimir@example.com'
user.name  # => 'Vladimir'
user.email # => 'vladimir@example.com'
```

You cannot define required **parameter** after optional one. The following example raises `SyntaxError` exception:

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer::Mixin

  param :name, default: proc { 'Unknown name' }
  param :email # => #<SyntaxError ...>
end
```

Set `nil` as a default value explicitly:

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer::Mixin

  param  :name
  option :email, default: proc { nil }
end

user = User.new 'Andrew'
user.email # => nil

user = User.new
# => #<ArgumentError ...>
```

You **must** wrap default values into procs.

If you need to **assign** proc as a default value, wrap it to another one:

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer::Mixin

  param :name_proc, default: proc { proc { 'Unknown user' } }
end

user = User.new
user.name_proc.call # => 'Unknown user'
```

Proc will be executed in a scope of new instance. You can refer to other arguments:

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer::Mixin

  param :name
  param :email, default: proc { "#{name.downcase}@example.com" }
end

user = User.new 'Andrew'
user.email # => 'andrew@example.com'
```

**Warning**: when using lambdas instead of procs, don't forget an argument, required by [instance_eval][instance_eval] (you can skip in in a proc).

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer::Mixin

  param :name, default: -> (obj) { 'Dude' }
end
```

[instance_eval]: http://ruby-doc.org/core-2.2.0/BasicObject.html#method-i-instance_eval
