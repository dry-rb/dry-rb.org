---
title: Reusing Schemas
layout: gem-single
order: 5
---

You can easily reuse existing schemas using nested-schema syntax:

``` ruby
AddressSchema = Dry::Validation.Schema do
  key(:street).required
  key(:city).required
  key(:zipcode).required
end

UserSchema = Dry::Validation.Schema do
  key(:email).required
  key(:name).required
  key(:address).schema(AddressSchema)
end

UserSchema.(
  email: 'jane@doe',
  name: 'Jane',
  address: { street: nil, city: 'NYC', zipcode: '123' }
).messages

# {:address=>{:street=>["must be filled"]}}
```
