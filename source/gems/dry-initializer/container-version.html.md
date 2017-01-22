---
title: Container Version
layout: gem-single
---

Instead of extending a class with the `Dry::Initializer`, you can include a container with the `initializer` method only. This method should be preferred when you don't need subclassing.

```ruby
require 'dry-initializer'
require 'dry-types'

class User
  # notice `-> do .. end` syntax
  include Dry::Initializer.define -> do
    param  :name,  Dry::Types['strict.string']
    param  :role,  default: proc { 'customer' }
    option :admin, default: proc { false }
  end
end
```

If you still need the DSL (`param` and `option`) to be inherited, use the direct extension:

```ruby
require 'dry-initializer'

class BaseService
  extend Dry::Initializer
  alias_method :dependency, :param
end

class ShowUser < BaseService
  dependency :user

  def call
    puts user&.name
  end
end
```
