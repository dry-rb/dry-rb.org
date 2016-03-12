---
title: Nested Data
layout: gem-single
order: 4
group: dry-validation
---

## Nested Data

`dry-validation` supports validation of nested data, this includes both hashes
and arrays as the validation input.

### Nested Hash

To define validation rules for a nested hash you can use the same DSL on a specific key:

``` ruby
require 'dry-validation'

class Schema < Dry::Validation::Schema
  key(:address) do |address|
    address.hash? do
      address.key(:city) do |city|
        city.min_size?(3)
      end

      address.key(:street) do |street|
        street.filled?
      end

      address.key(:country) do |country|
        country.key(:name, &:filled?)
        country.key(:code, &:filled?)
      end
    end
  end
end

schema = Schema.new

errors = schema.call({}).messages

puts errors.inspect
# { :address => ["address is missing"] }

errors = schema.call(address: { city: 'NYC' }).messages

puts errors.to_h.inspect
# {
#   :address => [
#     { :street => [["street is missing"], nil] },
#     { :country => [["country is missing"], nil] }
#   ]
# }
```

### Nested Array

You can use `each` rule for validating each element in an array:

``` ruby
class Schema < Dry::Validation::Schema
  key(:phone_numbers) do |phone_numbers|
    phone_numbers.array? do
      phone_numbers.each(&:str?)
    end
  end
end

schema = Schema.new

errors = schema.call(phone_numbers: '').messages

puts errors.inspect
# { :phone_numbers => [["phone_numbers must be an array"], ""] }

errors = schema.call(phone_numbers: ['123456789', 123456789]).messages

puts errors.inspect
# {
#   :phone_numbers => [
#     [{ :phone_numbers => [["phone_numbers must be a string"], 123456789] }],
#     ["123456789", 123456789]
#   ]
# }
```
