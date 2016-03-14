---
title: Struct & Value
layout: gem-single
name: types
order: 12
---

### Struct

You can define struct objects which will have readers for specified attributes using a simple dsl:

``` ruby
class User < Dry::Types::Struct
  attribute :name, Types::Maybe::Coercible::String
  attribute :age, Types::Coercible::Int
end

user = User.new(name: nil, age: '21')

user.name # None
user.age # 21

user = User(name: 'Jane', age: '21')

user.name # => Some("Jane")
user.age # => 21
```

### Value

You can define value objects which will behave like structs and have equality methods too:

``` ruby
class Location < Dry::Types::Value
  attribute :lat, Types::Strict::Float
  attribute :lat, Types::Strict::Float
end

loc1 = Location.new(lat: 1.23, lng: 4.56)
loc2 = Location.new(lat: 1.23, lng: 4.56)

loc1 == loc2
# true
```
