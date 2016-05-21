---
title: Strict
layout: gem-single
order: 3
---

All types in the `strict` category are [constrained](/gems/dry-types/constraints) by a type-check that is applied to an input which makes sure that the input is an instance of the primitive:

``` ruby
Types::Strict::Int[1] # => 1
Types::Strict::Int['1'] # => raises Dry::Types::ConstraintError
```
