---
title: Registry &amp; Resolver
layout: gem-single
name: dry-container
---

### Register options

#### `call`

This boolean option determines whether or not the registered item should be invoked when resolved, i.e.

```ruby
container = Dry::Container.new
container.register(:key_1, call: false) { "Integer: #{rand(1000)}" }
container.register(:key_2, call: true)  { "Integer: #{rand(1000)}" }

container.resolve(:key_1) # => <Proc:0x007f98c90454c0@dry_c.rb:23>
container.resolve(:key_1) # => <Proc:0x007f98c90454c0@dry_c.rb:23>

container.resolve(:key_2) # => "Integer: 157"
container.resolve(:key_2) # => "Integer: 713"
```

#### `memoize`

This boolean option determines whether or not the registered item should be memoized on the first invocation, i.e.

```ruby
container = Dry::Container.new
container.register(:key_1, memoize: true)  { "Integer: #{rand(1000)}" }
container.register(:key_2, memoize: false) { "Integer: #{rand(1000)}" }

container.resolve(:key_1) # => "Integer: 734"
container.resolve(:key_1) # => "Integer: 734"

container.resolve(:key_2) # => "Integer: 855"
container.resolve(:key_2) # => "Integer: 282"
```

### Customization

You can configure how items are registered and resolved from the container:

```ruby
class Container
  extend Dry::Container::Mixin

  registry ->(container, key, item, options) { container[key] = item }
  resolver ->(container, key) { container[key] }
end

class ContainerObject
  include Dry::Container::Mixin

  registry ->(container, key, item, options) { container[key] = item }
  resolver ->(container, key) { container[key] }
end
```

This allows you to customise the behaviour of Dry::Container, for example, the default registry (Dry::Container::Registry) will raise a Dry::Container::Error exception if you try to register under a key that is already used, you may want to just overwrite the existing value in that scenario, configuration allows you to do so.
