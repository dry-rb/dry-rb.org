---
title: JSON
layout: gem-single
name: dry-schema
---

To validate JSON data structures, you can use `JSON` schemas. The difference between `Params` and `JSON` is coercion logic. Refer to [dry-types](/gems/dry-types/built-in-types/) documentation for more information about supported JSON coercions.

## Examples

```ruby
schema = Dry::Schema.JSON do
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
