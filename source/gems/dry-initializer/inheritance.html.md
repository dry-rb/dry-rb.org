---
title: Inheritance
layout: gem-single
---

Subclassing preserves all definitions being made inside a superclass:

```ruby
require 'dry-initializer'

class User
  extend Dry::Initializer::Mixin

  param :name
end

class Employee < User
  param :position
end

employee = Employee.new('John', 'supercargo')
employee.name     # => 'John'
employee.position # => 'supercargo'
```
