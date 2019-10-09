---
title: Constraints
layout: gem-single
name: dry-types
---

## Using Constraint Objects for Validation

_Type objects_ can be used to validate that the input satisfies the provided type. There's two approaches to validation.

### Preferred Approach: Validate using `valid?`

```ruby
Dry::Types['strict.string'].valid?(123) # false
# => false
Dry::Types['strict.string'].valid?(true)
# => false
Dry::Types['strict.string'].valid?("a string")
# => true
```

This approach is useful when working with user-provided input.

### Alternate Approach: Validate by raising an exception

```ruby
Dry::Types['strict.string']["a string"]
# => "a string"

Dry::Types['strict.string'][123]
# => 123 violates constraints (type?(String, 123) failed)
```

## Adding Additional Constraints from the `dry-logic` Gem

`dry-types` objects inherit the ability to attach [`dry-logic`](/gems/dry-logic) requirements by calling `.constrained` on your object:

```ruby
email = Dry::Types['strict.string'].constrained(
  format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
)
# => #<Dry::Types[Constrained<Nominal<String> rule=[type?(String) AND format?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)]>]>
email["jane@doe.org"]
# => "jane@doe.org"
email["jane"]
# => "jane" violates constraints (format?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, "jane") failed)
```

Here's a quick glance of the [`dry-logic`](/gems/dry-logic/predicates) predicates, taken from the [`dry-logic`](/gems/dry-logic) docs:

  - `type?`
  - `none?`
  - `key?`
  - `attr?`
  - `empty?`
  - `filled?`
  - `bool?`
  - `date?`
  - `date_time?`
  - `time?`
  - `number?`
  - `int?`
  - `float?`
  - `decimal?`
  - `str?`
  - `hash?`
  - `array?`
  - `odd?`
  - `even?`
  - `lt?`
  - `gt?`
  - `lteq?`
  - `gteq?`
  - `size?`
  - `min_size?`
  - `max_size?`
  - `bytesize?`
  - `min_bytesize?`
  - `max_bytesize?`
  - `inclusion?`
  - `exclusion?`
  - `included_in?`
  - `excluded_from?`
  - `includes?`
  - `excludes?`
  - `eql?`
  - `not_eql?`
  - `true?`
  - `false?`
  - `format?`
  - `predicate`
  
  \* [See the full list here on the `dry-logic` docs](/gems/dry-logic/predicates) 

It's possible to check any input against any type, but it's up to you to set up constraints that make sense.
