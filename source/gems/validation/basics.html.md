---
title: Basics
layout: gem-single
order: 1
---

Here's a basic example where we validate following things:

* The input *must have a key* called `:email`
  * Provided the email key is present, its value *must be filled*
* The input *must have a key* called `:age`
  * Provided the age key is present, its value *must be an integer* and it *must be greater than 18*

This can be easily expressed through the DSL:

``` ruby
require 'dry-validation'

schema = Dry::Validation.Schema do
  key(:email).required
  key(:age).required(:int?, gt?: 18)
end

errors = schema.call(email: 'jane@doe.org', age: 19).messages

puts errors.inspect
# []

errors = schema.call(email: nil, age: 19).messages

puts errors.inspect
# { :email => ["must be filled"] }
```

A couple of remarks:

* `key` assumes that we want to use the `:key?` predicate to check the existance of that key
* `gt?(18)` translates to calling a predicate like this: `schema[:gt?].(18, age)`
* `int? & gt?(18)` is a conjunction, so we don't bother about `gt?` unless `int?` returns `true`
* You can also use `|` for disjunction
* Schema object does not carry the input as its state, nor does it know how to access the input values, we pass the input to `call` and get a result object
