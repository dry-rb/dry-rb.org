---
title: Form Validation
layout: gem-single
order: 7
group: dry-validation
---

## Form Validation

Probably the most common use case is to validate form params. This is a special kind of a validation for a couple of reasons:

* The input is a hash with stringified keys
* The input include values that are strings, hashes or arrays
* Prior validation, we need to coerce values and symbolize keys based on the information from rules

For that reason, `dry-validation` ships with `Schema::Form` class:

``` ruby
require 'dry-validation'

class UserFormSchema < Dry::Validation::Schema::Form
  key(:email) { |value| value.str? & value.filled? }

  key(:age) { |value| value.int? & value.gt?(18) }
end

schema = UserFormSchema.new

errors = schema.call('email' => '', 'age' => '18').messages

puts errors.inspect
# {
#   :email => [["email must be filled"], nil],
#   :age => [["age must be greater than 18"], 18]
# }
```

There are few major differences between how it works here and in `ActiveModel`:

* We have type checking as predicates, ie `gt?(18)` will not be applied if the value is not an integer
* Even though not all predicates might be applied, error messages include all information
* Coercion is handled by `dry-data` coercible hash using its `form.*` types that are dedicated for this type of coercions
* It's very easy to add your own types and coercions (more info/docs coming soon)
