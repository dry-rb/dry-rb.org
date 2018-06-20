---
title: Nested Data
layout: gem-single
name: dry-validation
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

errors = schema.call({}).errors

puts errors.inspect
# { :address => ["is missing"] }

errors = schema.call(address: { city: 'NYC' }).errors

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

my_schema = Dry::Validation.Schema do
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

my_schema.(address: nil).success? # true
```

### Nested Array

You can use the `each` macro for validating each element in an array:

``` ruby
my_schema = Dry::Validation.Schema do
  required(:phone_numbers).each(:str?)
end

errors = my_schema.call(phone_numbers: '').messages

puts errors.inspect
# { :phone_numbers => ["must be an array"] }

errors = my_schema.call(phone_numbers: ['123456789', 123456789]).messages

puts errors.inspect
# {
#   :phone_numbers => {
#     1 => ["must be a string"]
#   }
# }
```

Similarly, you use `each` and `schema` to validate an array of hashes:

``` ruby
my_schema = Dry::Validation.Schema do
  required(:people).each do
    schema do
      required(:name).filled(:str?)
      required(:age).filled(:int?, gteq?: 18)
    end
  end
end

errors = my_schema.call(
  people: [ { name: 'Alice', age: 19 }, { name: 'Bob', age: 17 } ],
).messages

errors = my_schema.call(phone_numbers: ['123456789', 123456789]).messages
puts errors.inspect
# => {
#   :people=>{
#     1=>{
#       :age=>["must be greater than or equal to 18"]
#     }
#   }
# }
```

To also validate the length of the array, compose using predicate logic operators:

``` ruby
my_schema = Dry::Validation.Schema do
  required(:people).filled do
    valid_size = min_size?(1) & max_size?(20)
    
    valid_contents = each do
      schema do
        required(:name).filled(:str?)
        required(:age).filled(:int?, gteq?: 18)
      end
    end
    
    valid_size & valid_contents
  end
end

errors = my_schema.call(
  people: [],
).messages

errors = my_schema.call(phone_numbers: ['123456789', 123456789]).messages
puts errors.inspect
# => {
#   :people=>["must be filled", "size cannot be less than 1", "size cannot be greater than 20"]
# }
```
