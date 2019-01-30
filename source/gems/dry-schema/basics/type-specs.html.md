---
title: Explicit type specs
layout: gem-single
name: dry-schema
---

To define what the expected type of a value is, you can use type specs. All macros support type specs as the first argument, whenever you pass a symbol that doesn't end with a question mark, or you explicitly pass in an instance of a `Dry::Types` object, it will be set as the type.

> Whenever you define a type spec, `dry-schema` will infer a type-check predicate.

## Examples

```ruby
UserSchema = Dry::Schema.Params do
  required(:login).filled(:string, min_size?: 3)

  required(:age).maybe(:integer, gt?: 18)

  required(:nums).value(array[:integer], size?: 3)

  # this is an equivalent of `filled(:date_time)`
  required(:login_time).filled(Types::Params::DateTime)
end
```
