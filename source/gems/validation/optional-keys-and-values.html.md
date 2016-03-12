---
title: Optional Keys and Values
layout: gem-single
order: 3
group: dry-validation
---

## Optional Keys And Values

We make a clear distinction between specifying an optional `key` and an optional
`value`. This gives you a way of being very specific about validation rules. You
can define a schema which can give you precise errors when a key was missing or
key was present but the value was nil.

This also comes with the benefit of being explicit about the type expectation.
In the example below we explicitly state that `:age` *can be nil* or it *can be an integer*
and when it *is an integer* we specify that it *must be greater than 18*.

You can define which keys are optional and define rules for their values:

``` ruby
require 'dry-validation'

class Schema < Dry::Validation::Schema
  key(:email) { |email| email.filled? }

  optional(:age) do |age|
    age.int? & age.gt?(18)
  end
end

schema = Schema.new

errors = schema.call(email: 'jane@doe.org').messages

puts errors.inspect
# {}

errors = schema.call(email: 'jane@doe.org', age: 17).messages

puts errors.inspect
# { :age => [["age must be greater than 18"], 17] }
```

## Optional Values

When it is valid for a given value to be `nil` you can use `none?` predicate:

``` ruby
require 'dry-validation'

class Schema < Dry::Validation::Schema
  key(:email) { |email| email.filled? }

  key(:age) do |age|
    age.none? | (age.int? & age.gt?(18))
  end
end

schema = Schema.new

errors = schema.call(email: 'jane@doe.org', age: nil).messages

puts errors.inspect
# {}

errors = schema.call(email: 'jane@doe.org', age: 19).messages

puts errors.inspect
# {}

errors = schema.call(email: 'jane@doe.org', age: 17).messages

puts errors.inspect
# { :age => [["age must be greater than 18"], 17] }
```
