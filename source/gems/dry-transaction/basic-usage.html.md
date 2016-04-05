---
title: Basic usage
layout: gem-single
---

### Providing a container

All you need to use dry-transaction is a container to hold your application’s operations. Each operation must respond to `#call(input)`.

The operations will be resolved from the container via `#[]`. For our examples, we’ll use a [`dry-container`](http://dry-rb.org/gems/dry-container):

```ruby
require "dry-container"
require "kleisli"

class Container
  extend Dry::Container::Mixin

  register :process, -> input { Right(name: input["name"], email: input["email"]) }
  register :validate, -> input { input[:email].nil? ? Left(:not_valid) : Right(input) }
  register :persist, -> input { DB << input; Right(:input) }
end
```

### Defining a transaction

Define a transaction to bring your opererations together:

```ruby
save_user = Dry.Transaction(container: Container) do
  step :process
  step :validate
  step :persist
end
```

### Calling a transaction

Calling a transaction will run its operations in their specified order, with the output of each operation becoming the input for the next.

```ruby
DB = []

save_user.call("name" => "Jane", "email" => "jane@doe.com")
# => Right({:name=>"Jane", :email=>"jane@doe.com"})

DB
# => [{:name=>"Jane", :email=>"jane@doe.com"}]
```

Each transaction returns a result value wrapped in a `Left` or `Right` object (based on the output of its final step). You can handle these results (including errors arising from particular steps) with a match block:

```ruby
save_user.call(name: "Jane", email: "jane@doe.com") do |m|
  m.success do |value|
    puts "Succeeded!"
  end

  m.failure :validate do |error|
    # Runs only when the transaction fails on the :validate step
    puts "Please provide a valid user."
  end

  m.failure do |error|
    # Runs for any failure (including :validate failures)
    puts "Couldn’t save this user."
  end
end
```

### Passing additional step arguments

You can pass additional arguments to step operations at the time of calling your transaction. Provide these arguments as an array, and they’ll be [splatted](https://endofline.wordpress.com/2011/01/21/the-strange-ruby-splat/) into the front of the operation’s arguments. This means that transactions can effectively support operations with any sort of `#call(*args, input)` interface.

```ruby
DB = []

class Container
  extend Dry::Container::Mixin

  register :process, -> input { Right(name: input["name"], email: input["email"]) }
  register :validate, -> allowed, input { input[:email].include?(allowed) ? Left(:not_valid) : Right(input) }
  register :persist, -> input { DB << input; Right(:input) }
end

save_user = Dry.Transaction(container: Container) do
  step :process
  step :validate
  step :persist
end

input = {"name" => "Jane", "email" => "jane@doe.com"}
save_user.call(input, validate: ["doe.com"])
# => Right({:name=>"Jane", :email=>"jane@doe.com"})

save_user.call(input, validate: ["smith.com"])
# => Left(:not_valid)
```

### Working with a larger container

In practice, your container won’t be a trivial collection of generically named operations. You can keep your transaction step names simple by using the `with:` option to provide the identifiers for the operations within your container:

```ruby
save_user = Dry.Transaction(container: LargeAppContainer) do
  step :process, with: "processors.process_user"
  step :validate, with: "validation.validate_user"
  step :persist, with: "persistance.commands.update_user"
end
```
