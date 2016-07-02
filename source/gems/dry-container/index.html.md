---
title: Introduction &amp; Usage
description: Simple, thread-safe container
layout: gem-single
order: 3
type: gem
name: dry-container
---

### Introduction

`dry-container` is a simple, thread-safe container, intended to be one half of the implementation of an [IoC](https://en.wikipedia.org/wiki/Inversion_of_control) container, when combined with [dry-auto_inject](/gems/dry-auto_inject/), this gem allows you to make use of the [dependency inversion principle](https://en.wikipedia.org/wiki/Dependency_inversion_principle), which would normally be ignored in *idiomatic* Ruby libraries in favour of hard-coded dependencies and/or wide interfaces.

Making use of the dependency inversion principle, with an IoC container and low-impact dependency resolution, allows you to follow many of the principles and practices that have been considered beneficial in software engineering for decades, such as SOLID. This is mostly because your objects (and their behaviour) can easily be composed of other small objects with narrow interfaces, and prividing you code to an interface, these dependencies can easily be swapped out later by simply registering a different object with the container.

### Brief Example

```ruby
container = Dry::Container.new
container.register(:parrot) { puts "Hello world" }

container.resolve(:parrot)
# >> Hello World
# => nil
```

### Detailed Example

```ruby
User = Struct.new(:name, :email)

data_store = ThreadSafe::Cache.new.tap do |ds|
  ds[:users] = ThreadSafe::Array.new
end

# Initialize container
container = Dry::Container.new

# Register an item with the container to be resolved later
container.register(:data_store, data_store)
container.register(:user_repository, -> { container.resolve(:data_store)[:users] })

# Resolve an item from the container
container.resolve(:user_repository) << User.new('Jack', 'jack@dry-container.com')
# You can also resolve with []
container[:user_repository] << User.new('Jill', 'jill@dry-container.com')
# => [
#      #<struct User name="Jack", email="jack@dry-container.com">,
#      #<struct User name="Jill", email="jill@dry-container.com">
#    ]

# If you wish to register an item that responds to call but don't want it to be
# called when resolved, you can use the options hash
container.register(:proc, -> { :result }, call: false)
container.resolve(:proc)
# => #<Proc:0x007fa75e652c98@(irb):25 (lambda)>

# You can also register using a block
container.register(:item) do
  :result
end
container.resolve(:item)
# => :result

container.register(:block, call: false) do
  :result
end
container.resolve(:block)
# => #<Proc:0x007fa75e6830f0@(irb):36>

# You can also register items under namespaces using the #namespace method
container.namespace('repositories') do
  namespace('checkout') do
    register('orders') { ThreadSafe::Array.new }
  end
end
container.resolve('repositories.checkout.orders')
# => []

# Or import a namespace
ns = Dry::Container::Namespace.new('repositories') do
  namespace('authentication') do
    register('users') { ThreadSafe::Array.new }
  end
end
container.import(ns)
container.resolve('repositories.authentication.users')
# => []
```

You can also get container behaviour at both the class and instance level via the mixin:

```ruby
class Container
  extend Dry::Container::Mixin
end
Container.register(:item, :my_item)
Container.resolve(:item)
# => :my_item

class ContainerObject
  include Dry::Container::Mixin
end
container = ContainerObject.new
container.register(:item, :my_item)
container.resolve(:item)
# => :my_item
```
### Using a custom registry/resolver

You can configure how items are registered and resolved from the container:

```ruby
Dry::Container.configure do |config|
  config.registry = ->(container, key, item, options) { container[key] = item }
  config.resolver = ->(container, key) { container[key] }
end

class Container
  extend Dry::Container::Mixin

  configure do |config|
    config.registry = ->(container, key, item, options) { container[key] = item }
    config.resolver = ->(container, key) { container[key] }
  end
end

class ContainerObject
  include Dry::Container::Mixin

  configure do |config|
    config.registry = ->(container, key, item, options) { container[key] = item }
    config.resolver = ->(container, key) { container[key] }
  end
end
```

This allows you to customise the behaviour of Dry::Container, for example, the default registry (Dry::Container::Registry) will raise a Dry::Container::Error exception if you try to register under a key that is already used, you may want to just overwrite the existing value in that scenario, configuration allows you to do so.
