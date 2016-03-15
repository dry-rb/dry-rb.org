---
title: Introduction & Usage
description: Predicate logic with composable rules
layout: gem-single
type: gem
---

Predicate logic and rule composition used by:

* [dry-types](https://github.com/dry-rb/dry-types) for constrained types
* [dry-validation](https://github.com/dry-rb/dry-validation) for composing validation rules
* your project...?

## Synopsis

``` ruby
require 'dry/logic'
require 'dry/logic/predicates'

include Dry::Logic

user_present = Rule::Key.new(Predicates[:key?], name: :user)

has_min_age = Rule::Key.new(
  Predicates[:key?].curry(:age) & Rule::Value.new(Predicates[:gt?].curry(18),
  name: :age
)

user_rule = user_present & has_min_age

user_rule.(user: { age: 19 })
# #<Dry::Logic::Result::Value success?=true input=19 rule=#<Dry::Logic::Rule::Value predicate=#<Dry::Logic::Predicate id=:gt?>>>

user_rule.(user: { age: 18 })
# #<Dry::Logic::Result::Value success?=false input=18 rule=#<Dry::Logic::Rule::Value predicate=#<Dry::Logic::Predicate id=:gt?>>>
```
