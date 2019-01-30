---
title: Introduction
description: Schema coercion & validation
layout: gem-single
type: gem
name: dry-schema
sections:
  - basics
  - optional-keys-and-values
  - nested-data
  - reusing-schemas
  - params
  - json
  - error-messages
  - advanced
  - extensions
---

> `dry-schema` will soon become the schema backend for dry-validation 1.0.0. For the time being, this documentation is very similar to dry-validation, as dry-schema's DSL is heavily based on it.
>
> You can learn more about dry-schema + dry-validation [here](https://discourse.dry-rb.org/t/plans-for-dry-validation-dry-schema-a-new-gem/215)!

`dry-schema` is a data coercion and validation library that focuses on explicitness, clarity and precision.

It is based on the idea that each validation is encapsulated by a simple, stateless predicate that receives some input and returns either `true` or `false`. Those predicates are encapsulated by `rules` which can be composed together using `predicate logic`. This means you can use the common logic operators to build up a validation `schema`.

Validations can be described with great precision, `dry-schema` eliminates ambiguous concepts like `presence` validation where we can't really say whether some attribute or key is _missing_ or it's just that the value is `nil`.

In `dry-schema` **type-safety is a first-class feature**, something that's completely missing in other validation libraries, and it's an important and useful feature. It means you can compose a validation that relies on the type of a given value. For example it makes no sense to try to validate each element of an array when it's not an array.

### The DSL

`dry-schema`'s rule composition and predicate logic is provided by [dry-logic](https://github.com/dry-rb/dry-logic). The DSL is a simple front-end for it. It allows you to define the rules by only using predicate identifiers. There are no magical options, conditionals and custom validation blocks known from other libraries. The focus is on pure validation logic expressed in a concise way.

### When To Use?

Always and everywhere. This is a general-purpose validation library that can be used for many things and **it's multiple times faster** than `ActiveRecord`/`ActiveModel::Validations` _and_ `strong-parameters`.

Possible use-cases include validation of:

- Form params
- "GET" params
- JSON documents
- YAML documents
- Application configuration (ie stored in ENV)
- Replacement for `strong-parameters`
- etc.

### Quick start

```ruby
require 'dry/schema'

UserSchema = Dry::Schema.Params do
  required(:name).filled
  required(:email).filled(format?: EMAIL_REGEX)
  required(:age).maybe(:integer)
  required(:address).schema do
    required(:street).filled
    required(:city).filled
    required(:zipcode).filled
  end
end

UserSchema.(
  name: 'Jane',
  email: 'jane@doe.org',
  address: { street: 'Street 1', city: 'NYC', zipcode: '1234' }
).inspect

# #<Dry::Schema::Result{:name=>"Jane", :email=>"jane@doe.org", :address=>{:street=>"Street 1", :city=>"NYC", :zipcode=>"1234"}} errors={:age=>["age is missing"]}>
```
