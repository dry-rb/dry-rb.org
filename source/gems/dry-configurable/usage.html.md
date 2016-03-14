---
title: Usage
layout: gem-single
---

`dry-configurable` is extremely simple to use, just extend the mixin and use the `setting` macro to add configuration options:

```ruby
class App
  extend Dry::Configurable

  # Pass a block for nested configuration (works to any depth)
  setting :database do
    # Can pass a default value
    setting :dsn, 'sqlite:memory'
  end
  # Defaults to nil if no default value is given
  setting :adapter
end

App.config.database.dsn
# => "sqlite:memory"

App.configure do |config|
  config.database.dsn = 'jdbc:sqlite:memory'
end

App.config.database.dsn
# => "jdbc:sqlite:memory"
App.config.adapter
# => nil
```
