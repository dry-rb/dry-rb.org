---
title: Usage
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

### Working with various operations via step adapters

`step` adds operations to your transaction that already return an `Either` object. If you have to work with other types of operations, you can use an alternative _step adapter_. Step adapters can wrap the output of your operations to make them easier to integrate into a transaction. The following adapters are available:

* `map` – any output is considered successful and returned as `Right(output)`
* `try` – the operation may raise an exception in an error case. This is caught and returned as `Left(exception)`. The output is otherwise returned as `Right(output)`.
* `tee` – the operation interacts with some external system and has no meaningful output. The original input is passed through and returned as `Right(input)`.

These step adapters in use look like this:

```ruby
save_user = Dry.Transaction(container: Container) do
  map :process
  try :validate, catch: ValidationError
  tee :persist
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

### Subscribing to step notifications

As well as pattern matching on the final transaction result, you can subscribe to individual steps and trigger specific behaviour based on their success or failure:

```ruby
NOTIFICATIONS = []

module UserPersistListener
  extend self

  def persist_success(user)
    NOTIFICATIONS << "#{user[:email]} persisted"
  end

  def persist_failure(user)
    NOTIFICATIONS << "#{user[:email]} failed to persist"
  end
end

input = {"name" => "Jane", "email" => "jane@doe.com"}

save_user.subscribe(persist: UserPersistListener)
save_user.call(input, validate: ["doe.com"])

NOTIFICATIONS
# => ["jane@doe.com persisted"]
```

This pub/sub mechanism is provided by the [Wisper](https://github.com/krisleech/wisper) gem. You can subscribe to specific steps using the `#subscribe(step_name: listener)` API, or subscribe to all steps via `#subscribe(listener)`.

### Modifying transactions

You can modify existing transactions by inserting or removing steps (with the modified transaction returned as a copy). See the [API docs](http://www.rubydoc.info/github/dry-rb/dry-transaction/Dry/Transaction/Sequence) for more information.

### Working with a larger container

In practice, your container won’t be a trivial collection of generically named operations. You can keep your transaction step names simple by using the `with:` option to provide the identifiers for the operations within your container:

```ruby
save_user = Dry.Transaction(container: LargeAppContainer) do
  step :process, with: "processors.process_user"
  step :validate, with: "validation.validate_user"
  step :persist, with: "persistance.commands.update_user"
end
```

### Providing custom step adapters

You can provide your own step adapters to add custom behaviour to transaction steps. Your step adapters must provide a single `#call(step, *args, input)` method, which shoud return the step’s result wrapped in an `Either` object.

You can provide your step adapter in a few different ways. You can add it to the built-in `StepAdapters` container (a [`dry-container`](http://dry-rb.org/gems/dry-container)) to make it available to all transactions in your codebase:

```ruby
Dry::Transaction::StepAdapters.register :custom_adapter, MyAdapter.new
```

Or you can make your own container to extend the built-in one, and then pass that to specific transactions:

```ruby
class MyStepAdapters < Dry::Transaction::StepAdapters
  register :custom_adapter, MyAdapter.new
end

save_user = Dry.Transaction(container: Container, step_adapters: MyStepAdapters) do
  # ...
end
```

An example of a custom step adapter is `enqueue`, which would run its operation in a background queue.

```ruby
QUEUE = []

class MyStepAdapters < Dry::Transaction::StepAdapters
  register :enqueue, -> step, *args, input {
    # In a real app, this would push the operation into a background worker queue
    QUEUE << step.operation.call(*args, input)

    Right(input)
  }
end

save_user = Dry.Transaction(container: Container, step_adapters: MyStepAdapters) do
  step :persist
  enqueue :send_welcome_email
end
```
