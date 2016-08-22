---
title: Optional Values
layout: gem-single
---

All built-in types have their optional versions too, you can access them under the `Types::Maybe::Strict` and `Types::Maybe::Coercible` namespaces:

``` ruby
Types::Maybe::Int[nil] # None
Types::Maybe::Int[123] # Some(123)

Types::Maybe::Coercible::Float[nil] # None
Types::Maybe::Coercible::Float['12.3'] # Some(12.3)
```

You can define your own optional types too:

``` ruby
maybe_string = Types::Strict::String.maybe

maybe_string[nil]
# => None

maybe_string[nil].fmap(&:upcase)
# => None

maybe_string['something']
# => Some('something')

maybe_string['something'].fmap(&:upcase)
# => Some('SOMETHING')

maybe_string['something'].fmap(&:upcase).value
# => "SOMETHING"
```

You can also define optional types which allow `nil` using a sum type, rather than use `Maybe`:

``` ruby
optional_string = Types::Strict::String.optional
# same as Types::Strict::Nil | Types::Strict::String

optional_string[nil]
# => nil

optional_string['something']
# => "something"

optional_string[123]
# raises Dry::Types::ConstraintError
```
