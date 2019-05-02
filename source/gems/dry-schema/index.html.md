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

TODO: write new intro

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
