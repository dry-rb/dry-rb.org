---
title: Params
layout: gem-single
name: dry-schema
---

Probably the most common use case is to validate HTTP params. This is a special kind of a validation for a couple of reasons:

- The input is a hash with stringified keys
- The input can include values that are strings, hashes or arrays
- Prior to validation, we need to coerce values and symbolize keys based on the information in the rules

For that reason, `dry-schema` ships with `Params` schemas:

```ruby
schema = Dry::Schema.Params do
  required(:email).filled

  required(:age).filled(:integer, gt?: 18)
end

errors = schema.call('email' => '', 'age' => '18').messages

puts errors.inspect
# {
#   :email => ["must be filled"],
#   :age => ["must be greater than 18"]
# }
```

> Form-specific value coercion is handled by a hash-schema using `dry-types`. It is built automatically for you based on the type expectations and used prior to applying the validation rules.

## Handling Empty Strings

Your schema will automatically coerce empty strings to `nil` or an empty array, provided that you allow a value to be nil:

```ruby
schema = Dry::Schema.Params do
  required(:email).filled

  required(:age).maybe(:integer, gt?: 18)
  required(:tags).maybe(:array)
end

result = schema.call('email' => 'jane@doe.org', 'age' => '', 'tags' => '')

puts result.to_h
# {:email=>'jane@doe.org', :age=>nil, :tags=>[]}
```
