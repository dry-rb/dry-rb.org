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

`dry-schema` is a validation library for **data structures**. It ships with a set of many built-in predicates and powerful macros that allow you to define even complex validation logic with very concise syntax.

Main focus of this library is on:

- Data **structure** validation
- Value **types** validation

> `dry-schema` is also used as the schema engine in [dry-validation](/gems/dry-validation)

### When To Use?

Always and everywhere. This is a general-purpose data validation library that can be used for many things and **it's multiple times faster** than `ActiveRecord`/`ActiveModel::Validations` _and_ `strong-parameters`.

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
  required(:name).filled(:string)
  required(:email).filled(:string)

  required(:age).maybe(:integer)

  required(:address).hash do
    required(:street).filled(:string)
    required(:city).filled(:string)
    required(:zipcode).filled(:string)
  end
end

UserSchema.(
  name: 'Jane',
  email: 'jane@doe.org',
  address: { street: 'Street 1', city: 'NYC', zipcode: '1234' }
).inspect

# #<Dry::Schema::Result{:name=>"Jane", :email=>"jane@doe.org", :address=>{:street=>"Street 1", :city=>"NYC", :zipcode=>"1234"}} errors={:age=>["age is missing"]}>
```
