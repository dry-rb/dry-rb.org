---
title: Custom Plugins
layout: gem-single
---

You can add custom plugins to handle params and options inside the initializer.

To add the plugin you have to:

* provide a specific class to build either a chunk of code for the initializer,
  or a proc to be evaluated in its scope.

* register a builder when extending klass with the plugin.

In the following example we add plugin that reports a value of the argument into stdin:

### String-Builder Example

```ruby
require 'dry-initializer'

module Dry::Initializer::Reporter
  # Provide a code builder as a subclass of the base plugin
  class Builder < Dry::Initializer::Plugins::Base
    # its method `call` will return a chunk of code
    def call
      "puts @#{name}" # the `##name` private method is a name of the param/option
    end
  end

  # Register a builder when using the plugin
  def self.extended(klass)
    klass.register_initializer_plugin Builder
  end
end

# Extend the target class with a new plugin
class User
  extend Dry::Initializer::Mixin
  extend Dry::Initializer::Reporter

  param :name, default: -> { 'Dude' }
end

User.new "Andrew"
# puts Andrew
```

### Proc-Builder Example

In the previous example code chunks are evaluated **before** default value setter:

```ruby
User.new
# puts Dry::Initializer::UNDEFINED
```

You can change your plugin so that its `#call` method to return proc instead of string:

```ruby
class Builder < Dry::Initializer::Plugins::Base
  def call
    ivar = :"@#{name}"
    proc { puts instance_variable_get(ivar) }
  end
end
```

This proc will be evaluated after default value assignment:

```ruby
class User
  extend Dry::Initializer::Mixin
  extend Dry::Initializer::Reporter

  param :name, default: -> { 'Dude' }
end

User.new
# puts Dude
```

Unfortunately, proc version is slow due to `instance_eval`. Do not overuse it!

### Using Settings

Examples above don't need additional settings. Let's implement a simple value coercer:

```ruby
require 'dry-initializer'

module Dry::Initializer::Coercion
  class Builder
    # The `##settings` private method returns a hash of settings for param/option
    return unless settings.key? :coercer

    ivar = :"@#{name}"
    coercer = settings[:coercer]

    proc do
      old_value = instance_variable_get(ivar)
      new_value = old_value.instance_eval(coercer)

      instance_variable_get(ivar, new_value)
    end
  end

  def self.extended(klass)
    klass.register_initializer_plugin Builder
  end
end
```

Now you can assign a coercer under the `:coercer` key:

```ruby
class User
  extend Dry::Initializer::Mixin
  extend Dry::Initializer::Coercion

  param :name, coercer: ->(value) { "Dear " << value.to_s }
end

user = User.new "Andrew"
user.name # => "Dear Andrew"
```

### Container Syntax

If you prefer [container syntax][container-syntax], extend plugin inside the block:

```ruby
require 'dry-initializer-rails'

class CreateOrder
  include Dry::Initializer.define -> do
    extend Dry::Initializer::Coercion

    # ... params/options declarations
  end
end
```

[container-syntax]: http://dry-rb.org/gems/dry-initializer/container-version/
