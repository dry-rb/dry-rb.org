---
title: Constraints
layout: gem-single
---

You can create constrained types that will use validation rules to check if the input is not violating any of the configured contraints. You can treat it as a lower level guarantee that you're not instantiating objects that are broken.

All types support constraints API, but not all constraints are suitable for a particular primitive, it's up to you to set up constraints that make sense.

Under the hood it uses [`dry-logic`](/gems/dry-logic) and all of its predicates are supported.

``` ruby
string = Types::Strict::String.constrained(min_size: 3)

string['foo']
# => "foo"

string['fo']
# => Dry::Types::ConstraintError: "fo" violates constraints

email = Types::Strict::String.constrained(
  format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
)

email["jane@doe.org"]
# => "jane@doe.org"

email["jane"]
# => Dry::Types::ConstraintError: "jane" violates constraints
```
