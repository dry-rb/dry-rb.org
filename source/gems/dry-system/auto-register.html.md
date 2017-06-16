---
title: Auto-Register
layout: gem-single
---

When defining a container we can specify which folder we want to register its content thanks to the `auto_register` configuration.

There is two options if you want to control the auto-registration process:

Placing in the top of a file `# auto_register: false` will skip the process.

```ruby
require 'dry/system/container'

class Application < Dry::System::Container
  configure do |config|
    config.root = './my/app'
    config.auto_register = 'lib'
  end

  load_paths!('lib')
end

# under /my/app/lib/user.rb we put
class User
  # some user custom logic
end

# under /my/app/lib/custom_logger.rb we put

# auto_register: false
class CustomLogger
  # this class will not be loaded
end
```

Using `auto_register!` with a block will yield a configuration object that will allow to control the auto-registration process of each of our components, providing support for managing the initialization process of the components and excluding any component if we need to (both optional)

``` ruby
require 'dry/system/container'

class Application < Dry::System::Container
  configure do |config|
    config.root = './my/app'
  end

  auto_register!('lib') do |config|
    config.instance do |component|
      # custom logic for initializing a component
    end

    config.exclude do |component|
      # return true to skip auto-registration of the component, e.g.
      # component.path =~ /entities/
    end
  end

  # this alters $LOAD_PATH hence the `!`
  load_paths!('lib')
end
```
