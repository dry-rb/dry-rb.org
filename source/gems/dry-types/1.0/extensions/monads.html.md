---
title: Monads
layout: gem-single
name: dry-types
---

The monads extension makes `Dry::Types::Result` objects compatible with `dry-monads`.

To enable the extension:

```ruby
require 'dry/types'

Dry::Types.load_extensions(:monads)
```

After loading the extension, you can leverage monad API:

```ruby
string_type = Dry::Types['strict.string']

result = string_type.try('Jane')
result.class #=> Dry::Types::Result::Success
monad = result.to_monad
monad.class #=> Dry::Monads::Result::Success
monad.value!  # => 'Jane'

result = string_type.try(nil)
result.class #=> Dry::Types::Failure
monad = result.to_monad
monad.class #=> Dry::Monads::Result::Failure
monad.failure  # => [#<Dry::Types::ConstraintError>, nil]

string_type.try(nil)
  .to_monad
  .fmap { |result| puts "passed: #{result.inspect}" }
  .or   { |error, input| puts "input '#{input.inspect}' failed with error: #{error.to_s}" }
```

This can be useful when used with `dry-monads` and the [`do` notation](/gems/dry-monads/do-notation/).
