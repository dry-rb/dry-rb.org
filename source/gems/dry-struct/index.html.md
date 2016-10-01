---
title: Introduction
layout: gem-single
type: gem
name: dry-struct
---

### Synopsis

You can define struct objects which will have readers for specified attributes using a simple dsl:

``` ruby
require 'dry-struct'

module Types
  include Dry::Types.module
end

class User < Dry::Struct
  attribute :name, Types::String.optional
  attribute :age, Types::Coercible::Int
end

user = User.new(name: nil, age: '21')

user.name # nil
user.age # 21

user = User.new(name: 'Jane', age: '21')

user.name # => "Jane"
user.age # => 21
```

### Value

You can define value objects which will behave like structs but will be *deeply frozen*:

``` ruby
class Location < Dry::Struct::Value
  attribute :lat, Types::Strict::Float
  attribute :lng, Types::Strict::Float
end

loc1 = Location.new(lat: 1.23, lng: 4.56)
loc2 = Location.new(lat: 1.23, lng: 4.56)

loc1.frozen? # true
loc2.frozen? # true

loc1 == loc2
# true
```
