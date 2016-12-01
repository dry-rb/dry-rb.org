---
title: Nested Data
layout: gem-single
---

`dry-validation` supports validation of nested data, this includes both hashes and arrays as the validation input.

### Nested Hash

To define validation rules for a nested hash you can use the same DSL on a specific key:

``` ruby
require 'dry-validation'

schema = Dry::Validation.Schema do
  required(:address).schema do
    required(:city).filled(min_size?: 3)

    required(:street).filled

    required(:country).schema do
      required(:name).filled
      required(:code).filled
    end
  end
end

errors = schema.call({}).messages

puts errors.inspect
# { :address => ["is missing"] }

errors = schema.call(address: { city: 'NYC' }).messages

puts errors.to_h.inspect
# {
#   :address => [
#     { :street => ["is missing"] },
#     { :country => ["is missing"] }
#   ]
# }
```

### Nested Maybe Hash

If a nested hash could be nil, simply use `maybe` macro with a block:

``` ruby
require 'dry-validation'

schema = Dry::Validation.Schema do
  required(:address).maybe do
    schema do
      required(:city).filled(min_size?: 3)

      required(:street).filled

      required(:country).schema do
        required(:name).filled
        required(:code).filled
      end
    end
  end
end

schema.(address: nil).success? # true
```

### Nested Array

You can use `each` macro for validating each element in an array:

``` ruby
schema = Dry::Validation.Schema do
  required(:phone_numbers).each(:str?)
end

errors = schema.call(phone_numbers: '').messages

puts errors.inspect
# { :phone_numbers => ["must be an array"] }

errors = schema.call(phone_numbers: ['123456789', 123456789]).messages

puts errors.inspect
# {
#   :phone_numbers => {
#     1 => ["must be a string"]
#   }
# }
```
