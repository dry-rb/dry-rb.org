---
title: Basics
layout: gem-single
order: 1
group: dry-validation
---

## Basics

Here's a basic example where we validate following things:

* The input *must have a key* called `:email`
  * Provided the email key is present, its value *must be filled*
* The input *must have a key* called `:age`
  * Provided the age key is present, its value *must be an integer* and it *must be greater than 18*

This can be easily expressed through the DSL:

``` ruby
require 'dry-validation'

class Schema < Dry::Validation::Schema
  key(:email) { |email| email.filled? }

  key(:age) do |age|
    age.int? & age.gt?(18)
  end
end

schema = Schema.new

errors = schema.call(email: 'jane@doe.org', age: 19).messages

puts errors.inspect
# []

errors = schema.call(email: nil, age: 19).messages

puts errors.inspect
# { :email => [["email must be filled"], nil] }
```

A couple of remarks:

* `key` assumes that we want to use the `:key?` predicate to check the existance of that key
* `age.gt?(18)` translates to calling a predicate like this: `schema[:gt?].(18, age)`
* `age.int? & age.gt?(18)` is a conjunction, so we don't bother about `gt?` unless `int?` returns `true`
* You can also use `|` for disjunction
* Schema object does not carry the input as its state, nor does it know how to access the input values, we
  pass the input to `call` and get error set as the response
