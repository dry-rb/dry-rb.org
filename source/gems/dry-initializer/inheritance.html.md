---
title: Inheritance
layout: gem-single
---

Subclassing preserves all definitions being made inside a superclass.

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer

  param :name
end

class Employee < User
  param :position
end

employee = Employee.new('John', 'supercargo')
employee.name     # => 'John'
employee.position # => 'supercargo'

employee = Employee.new # => fails because type
```

You can reload params and options.
Such a reloading leaves initial order of params (positional arguments) unchanged:

```ruby
class Employee < User
  param :position, optional: true
  param :name,     default:  proc { 'Unknown' }
end

User.new
# => Boom! because User#name is required

Employee.new.name
# => 'Unknown' (name is positioned first like in User)
```
