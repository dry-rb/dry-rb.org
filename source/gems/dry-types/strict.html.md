---
title: Strict
layout: gem-single
order: 3
---

Under `strict` category all types are [constrained](/gems/dry-types/constraints) by a type-check that is applied to an input which makes sure that the input is an instance of the primitive:

``` ruby
Types::Strict::Int[1] # => 1
Types::Strict::Int['1'] # => raises Dry::Types::ConstraintError
```
