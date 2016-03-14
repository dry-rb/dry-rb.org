---
title: Sum Types
layout: gem-single
name: types
order: 7
---

You can specify sum types using `|` operator, it is an explicit way of defining what are the valid types of a value.

In example `dry-types` defines `Bool` type which is a sum consisting of `True` and `False` types which is expressed as `Types::True | Types::False` (and it has its strict version, too).

Another common case is defining that something can be either `nil` or something else:

``` ruby
nil_or_string = Types::Nil | Types::Strict::String

nil_or_string[nil] # => nil
nil_or_string["hello"] # => "hello"
```
