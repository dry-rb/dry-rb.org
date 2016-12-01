---
title:  Shared Settings
layout: gem-single
---

Instead of repeating settings like `type`, `default`, and `optional` for every single param and option:

```ruby
require 'dry-initializer'
require 'dry-types'

class User
  extend Dry::Initializer::Mixin

  param  :name,  type: Dry::Types["strict.string"], optional: true
  option :email, type: Dry::Types["strict.string"], optional: true, reader: private
  option :male,  type: Dry::Types["form.bool"],     optional: true, reader: private
end
```

you can share them via `#using` method (inside the block shared options can be reloaded):

```ruby
require 'dry-initializer'
require 'dry-types'

class User
  extend Dry::Initializer::Mixin

  using type: Dry::Types["strict.string"], optional: true, reader: :private do
    param  :name, reader: :public
    option :email
    option :male, type: Dry::Types["form.bool"]
  end
end
```
