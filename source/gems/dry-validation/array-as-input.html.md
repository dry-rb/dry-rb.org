---
title: Array As Input
layout: gem-single
---

A schema can accept either a hash or an array as the input. If you want to define a schema for an array, simply use `each`:

``` ruby
schema = Dry::Validation.Schema do
  each do
    schema do
      key(:name).required
      key(:age).required
    end
  end
end

schema.([{ name: 'Jane', age: 21 }, { name: 'Joe', age: nil }]).messages
# { 1 => { age: ['must be filled'] } }
```
