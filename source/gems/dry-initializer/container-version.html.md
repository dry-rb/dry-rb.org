---
title: Container Version
layout: gem-single
---

Instead of extending a class with the `Dry::Initializer::Mixin`, you can include a container with the initializer:

```ruby
require 'dry-initializer'

class User
  # notice `-> do .. end` syntax
  include Dry::Initializer.define -> do
    param  :name,  type: String
    param  :role,  default: proc { 'customer' }
    option :admin, default: proc { false }
  end
end
```

Now you do not pollute a class with new variables, but isolate them in a special "container" module with the initializer and attribute readers. This method should be preferred when you don't need subclassing.

If you still need the DSL (`param` and `option`) to be inherited, use the direct extension:

```ruby
require 'dry-initializer'

class BaseService
  extend Dry::Initializer::Mixin
  alias_method :dependency, :param
end

class ShowUser < BaseService
  dependency :user

  def call
    puts user&.name
  end
end
```
