---
title: Introduction
layout: gem-single
type: gem
name: dry-struct
---

`dry-struct` is a gem built on top of `dry-types` which provides virtus-like DSL for defining typed struct classes.

### Basic Usage

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

### Constructor Types

Your struct class can specify a constructor type, which uses [hash schemas](/gems/dry-types/hash-schemas) to handle attributes in `.new` method. By default `:permissive` constructor is used.

To set a different constructor type simply use `constructor_type` setting:

``` ruby
class User < Dry::Struct
  constructor_type :strict

  attribute :name, Types::Strict::String
  attribute :age, Types::Strict::Int
end

User.new(name: "Jane", age: 31)
# => #<User name="Jane" age=31>

User.new(name: "Jane", age: 31, unexpected: "attribute")
# Dry::Struct::Error: [User.new] unexpected keys [:unexpected] in Hash input

class Admin < Dry::Struct
  constructor_type :schema

  attribute :name, Types::Strict::String.default('John Doe')
  attribute :age, Types::Strict::Int
end

Admin.new(name: "Jane")        #=> #<User name="Jane" age=nil>
Admin.new(age: 31)             #=> #<User name="John Doe" age=31>
Admin.new(name: nil, age: 31)  #=> #<User name="John Doe" age=31>
Admin.new(name: "Jane", age: 31, unexpected: "attribute")
  #=> #<User name="Jane" age=31>
```

Common constructor types include:

* `:permissive` - the default constructor type, useful for defining structs that are instantiated using data from the database (ie results of a database query), where you expect *all defined attributes to be present* and it's OK to ignore other keys (ie keys used for joining, that are not relevant from your domain structs point of view). Default values **are not used** otherwise you wouldn't notice missing data.
* `:schema` - missing keys will result in setting them using default values, unexpected keys will be ignored.
* `:strict` - useful when you *do not expect keys other than the ones you specified as attributes* in the input hash
* `:strict_with_defaults` - same as `:strict` but you are OK that some values may be nil and you want defaults to be set
* `:weak` and `:symbolized` - *don't use those with dry-struct*, and instead use dry-validation to process and validate attributes, otherwise your struct will behave as a data validator which raises exceptions on invalid input (assuming your attributes types are strict)

### Differences between dry-struct and virtus

`dry-struct` look somewhat similar to Virtus but there are few significant differences:

* Structs don't provide attribute writers and are meant to be used as "data objects" exclusively
* Handling of attribute values is provided by standalone type objects from `dry-types`, which gives you way more powerful features
* Handling of attribute hashes is provided by standalone hash schemas from `dry-types`, which means there are different types of constructors in `dry-struct`
* Structs are not designed as swiss-army knifes, specific constructor types are used depending on the use case
* Struct classes quack like `dry-types`, which means you can use them in hash schemas, as array members or sum them
