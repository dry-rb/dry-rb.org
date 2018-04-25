---
title: Task
layout: gem-single
name: dry-monads
---

`Task` represents an asynchronous computation. It is similar to the `IO` type in a sense it can be used to wrap side-effectful actions. `Task`s are usually run on a thread pool but also can be executed immediately on the current thread. Internally, `Task` uses `Promise` from the `concurrent-ruby` gem, basically it's a thin wrapper with a monadic interface which makes it easily compatible with other monads.

### `Task::Mixin`

The following examples use the Ruby 2.5+ syntax which allows passing a block to `.[]`.

```ruby
require 'dry-monads'

class PullUsersWithPosts
  include Dry::Monads::Task::Mixin

  def call
    # Start two tasks running concurrently
    users = Task { fetch_users }
    posts = Task { fetch_posts }

    # Combine two tasks
    users.bind { |us| posts.fmap { |ps| [us, ps] } }
  end

  def fetch_users
    sleep 3
    [{ id: 1, name: 'John' }, { id: 2, name: 'Jane' }]
  end

  def fetch_posts
    sleep 2
    [
      { id: 1, user_id: 1, name: 'Hello from John' },
      { id: 2, user_id: 2, name: 'Hello from Jane' },
    ]
  end
end

# ResultCalculator instance
pull = ResultCalculator.new

# If everything went success
c.input = 3
result = c.calculate
result # => Success(12)

# If it failed in the first block
c.input = 0
result = c.calculate
result # => Failure("value was less than 1")

# if it failed in the second block
c.input = 2
result = c.calculate
result # => Failure("value was not even")
```

### `bind`

Use `bind` for composing several possibly-failing operations:

```ruby
require 'dry-monads'

M = Dry::Monads

class AssociateUser
  def call(user_id:, address_id:)
    find_user(user_id).bind do |user|
      find_address(address_id).fmap do |address|
        user.update(address_id: address.id)
      end
    end
  end

  private

  def find_user(id)
    user = User.find(id)

    if user
      Success(user)
    else
      Failure(:user_not_found)
    end
  end

  def find_address(id)
    address = Address.find(id)

    if address
      Success(address)
    else
      Failure(:address_not_found)
    end
  end
end

AssociateUser.new.(user_id: 1, address_id: 2)
```

### `fmap`

An example of using `fmap` with `Success` and `Failure`.

```ruby
require 'dry-monads'

M = Dry::Monads

result = if foo > bar
  M.Success(10)
else
  M.Failure("wrong")
end.fmap { |x| x * 2 }

# If everything went success
result # => Success(20)
# If it did not
result # => Failure("wrong")

# #fmap accepts a proc, just like #bind

upcase = :upcase.to_proc

M.Success('hello').fmap(upcase) # => Success("HELLO")
```

### `value_or`

`value_or` is a safe and recommended way of extracting values.

```ruby
M = Dry::Monads

M.Success(10).value_or(0) # => 10
M.Failure('Error').value_or(0) # => 0
```

### `value!`

If you're 100% sure you're dealing with a `Success` case you might use `value!` for extracting the value without providing a default. Beware, this will raise an exception if you call it on `Failure`.

```ruby
M = Dry::Monads

M.Success(10).value! # => 10

M.Failure('Error').value!
# => Dry::Monads::UnwrapError: value! was called on Failure
```

### `or`

An example of using `or` with `Success` and `Failure`.

```ruby
M = Dry::Monads

M.Success(10).or(M.Success(99)) # => Success(10)
M.Failure("error").or(M.Failure("new error")) # => Failure("new error")
M.Failure("error").or { |err| M.Failure("new #{err}") } # => Failure("new error")
```

### `failure`

Use `failure` for unwrapping the value from a `Failure` instance.

```ruby
M = Dry::Monads

M.Failure('Error').failure # => "Error"
```

### `to_maybe`

Sometimes it's useful to turn a `Result` into a `Maybe`.

```ruby
require 'dry-monads'

result = if foo > bar
  Dry::Monads.Success(10)
else
  Dry::Monads.Failure("wrong")
end.to_maybe

# If everything went success
result # => Some(10)
# If it did not
result # => None()
```

### `failure?` and `success?`

You can explicitly check the type by calling `failure?` or `success?` on a monadic value.
