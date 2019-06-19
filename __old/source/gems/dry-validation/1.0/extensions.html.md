---
title: Extensions
layout: gem-single
name: dry-validation
---

### Monads

The monads extension makes `Dry::Validation::Result` objects compatible with `dry-monads`.

To enable the extension:

```ruby
require 'dry/validation'

Dry::Validation.load_extensions(:monads)
```

After loading the extension, you can leverage monad API:

``` ruby
class MyContract < Dry::Validation::Contract
  params do
    required(:name).filled(:string)
  end
end

my_contract = MyContract.new

my_contract.(name: "")
  .to_monad
  .fmap { |r| puts "passed: #{r.to_h.inspect}" }
  .or   { |r| puts "failed: #{r.errors.to_h.inspect}" }
```
