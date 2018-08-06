---
title: Monads
layout: gem-single
name: dry-validation
---

This extension add a new method (`#to_monad`) to your schema.

```ruby
schema = Dry::Validation.Schema { required(:name).filled(:str?, size?: 2..4) }
schema.call(name: 'Jane').to_either # => Dry::Monads::Success({ name: 'Jane' })
schema.call(name: '').to_either     # => Dry::Monads::Failure(name: ['name must be filled', 'name length must be within 2 - 4'])
```

This can be useful when used with `dry-monads` and the [`do` notation](/gems/dry-monads/do-notation/).
