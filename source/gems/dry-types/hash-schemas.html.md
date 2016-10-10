---
title: Hash Schemas
layout: gem-single
---

The built-in `Hash` type has constructors that you can use to define hashes with explicit schemas and coercible values using the built-in types.

### Hash Schema

``` ruby
# using simple kernel coercions
hash = Types::Hash.schema(name: Types::String, age: Types::Coercible::Int)

hash[name: 'Jane', age: '21']
# => { :name => "Jane", :age => 21 }

# using form param coercions
hash = Types::Hash.schema(name: Types::String, birthdate: Form::Date)

hash[name: 'Jane', birthdate: '1994-11-11']
# => { :name => "Jane", :birthdate => #<Date: 1994-11-11 ((2449668j,0s,0n),+0s,2299161j)> }
```

### Permissive Schema

Permissive hash will raise errors when keys are missing or value types are incorrect.

``` ruby
hash = Types::Hash.permissive(name: Types::String, age: Types::Coercible::Int)

hash[email: 'jane@doe.org', name: 'Jane', age: 21]
# => Dry::Types::SchemaKeyError: :email is missing in Hash input
```

### Symbolized Schema

Symbolized hash will turn string key names into symbols

``` ruby
hash = Types::Hash.symbolized(name: Types::String, age: Types::Coercible::Int)

hash['name' => 'Jane', 'age' => '21']
# => { :name => "Jane", :age => 21 }
```
