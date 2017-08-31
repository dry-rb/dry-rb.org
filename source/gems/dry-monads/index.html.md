---
title: Introduction & Usage
description: Common monads for Ruby
layout: gem-single
type: gem
name: dry-monads
---

## Introduction

`dry-monads` is a set of common monads for Ruby.

Monads provide an elegant way of handling errors, exceptions and chaining functions so that the code is much more understandable and has all the error handling, without all the `if`'s and `else`'s. The gem was inspired by [Kleisli](https://github.com/txus/kleisli) gem.

See [dry-matcher](/gems/dry-matcher/) for an example of how to use monads for controlling the flow of code with a result.

## Usage

### Maybe monad

The `Maybe` monad is used when a series of computations could return `nil` at any point.

#### `bind`

Applies a block to a monadic value. If the value is `Some` then calls the block passing unwrapped value as an argument. Returns itself if the value is `None`.

```ruby
require 'dry-monads'

M = Dry::Monads

maybe_user = M.Maybe(user).bind do |u|
  M.Maybe(u.address).bind do |a|
    M.Maybe(a.street)
  end
end

# If user with address exists
# => Some("Street Address")
# If user or address is nil
# => None()

# You also can pass a proc to #bind

add_two = -> (x) { M.Maybe(x + 2) }

M.Maybe(5).bind(add_two).bind(add_two) # => Some(9)
M.Maybe(nil).bind(add_two).bind(add_two) # => None()

```

#### `fmap`

Similar to `bind` but lifts the result for you.

```ruby
require 'dry-monads'

Dry::Monads::Maybe(user).fmap(&:address).fmap(&:street)

# If user with address exists
# => Some("Street Address")
# If user or address is nil
# => None()
```


#### `value`

You always can unlift the result by calling `value`.

```ruby
require 'dry-monads'

Dry::Monads::Some(5).fmap(&:succ).value # => 6

Dry::Monads::None().fmap(&:succ).value # => nil

```

#### `or`

The opposite of `bind`.

```ruby
require 'dry-monads'

M = Dry::Monads

add_two = -> (x) { M.Maybe(x + 2) }

M.Maybe(5).bind(add_two).bind(add_two).or(M.Some(1)) # => Some(9)
M.Maybe(nil).bind(add_two).bind(add_two).or(M.Some(1)) # => Some(1)
```

### Either monad

The `Either` monad is useful to express a series of computations that might
return an error object with additional information.

The `Either` mixin has two type constructors: `Right` and `Left`. The `Right`
can be thought of as "everything went right" and the `Left` is used when
"something has gone wrong".

#### `Either::Mixin`

```ruby
require 'dry-monads'

class EitherCalculator
  include Dry::Monads::Either::Mixin

  attr_accessor :input

  def calculate
    i = Integer(input)

    Right(i).bind do |value|
      if value > 1
        Right(value + 3)
      else
        Left("value was less than 1")
      end
    end.bind do |value|
      if value % 2 == 0
        Right(value * 2)
      else
        Left("value was not even")
      end
    end
  end
end

# EitherCalculator instance
c = EitherCalculator.new

# If everything went right
c.input = 3
result = c.calculate
result # => Right(12)
result.value # => 12

# If it failed in the first block
c.input = 0
result = c.calculate
result # => Left("value was less than 1")
result.value # => "value was less than 1"

# if it failed in the second block
c.input = 2
result = c.calculate
result # => Left("value was not even")
result.value # => "value was not even"
```

#### `fmap`

An example of using `fmap` with `Right` and `Left`.

```ruby
require 'dry-monads'

M = Dry::Monads

result = if foo > bar
  M.Right(10)
else
  M.Left("wrong")
end.fmap { |x| x * 2 }

# If everything went right
result # => Right(20)
# If it did not
result # => Left("wrong")

# #fmap accepts a proc, just like #bind

upcase = :upcase.to_proc

M.Right('hello').fmap(upcase) # => Right("HELLO")
```

#### `value`

Unlift the result by calling `value`.

```ruby
M = Dry::Monads

M.Right(10).value # => 10
M.Left('Error').value # => 'Error'

```

#### `or`

An example of using `or` with `Right` and `Left`.

```ruby
M = Dry::Monads

M.Right(10).or(M.Right(99)) # => Right(10)
M.Left("error").or(M.Left("new error")) # => Left("new error")
M.Left("error").or { |err| M.Left("new #{err}") } # => Left("new error")
```

#### `to_maybe`

Sometimes it's useful to turn an `Either` into a `Maybe`.

```ruby
require 'dry-monads'

result = if foo > bar
  Dry::Monads.Right(10)
else
  Dry::Monads.Left("wrong")
end.to_maybe

# If everything went right
result # => Some(10)
# If it did not
result # => None()
```

#### `left?` and `right?`

You can explicitly check the type by calling `left?` or `right?` on a monadic value. Also `left?` has `failure?` alias and `right?` has `success?`.

### Try monad

Rescues a block from an exception. `Try` monad is useful when you want to wrap some code that can raise exceptions of certain types. A common example is making HTTP request or querying a database.

```ruby
require 'dry-monads'

module ExceptionalLand
  extend Dry::Monads::Try::Mixin

  res = Try() { 10 / 2 }
  res.value if res.success?
  # => 5

  res = Try() { 10 / 0 }
  res.exception if res.failure?
  # => #<ZeroDivisionError: divided by 0>

  # By default Try catches all exceptions inherited from StandardError.
  # However you can catch only certain exceptions like this
  Try(NoMethodError, NotImplementedError) { 10 / 0 }
  # => raised ZeroDivisionError: divided by 0 exception
end
```

It is better if you pass a list of expected exceptions which you are sure you can process. Catching exceptions of all types is considered bad practice.

`Try` monad consists of two types: `Success` and `Failure`. The first is returned when code did not raise an error and the second is returned when the error was captured.


#### `bind`

Works exactly the same as `Either#bind` does.

```ruby
require 'dry-monads'

module ExceptionalLand
  extend Dry::Monads::Try::Mixin

  Try() { 10 / 2 }.bind { |x| x * 3 }
  # => 15

  Try(ZeroDivisionError) { 10 / 0 }.bind { |x| x * 3 }
  # => Failure(ZeroDivisionError: divided by 0)
end
```

#### `fmap`

Allows you to chain blocks that can raise exceptions.

```ruby
Try(NetworkError, DBError) { grap_user_by_making_request }.fmap { |user| user_repo.save(user) }

# Possible outcomes:
# => Success(persisted_user)
# => Failure(NetworkError: request timeout)
# => Failure(DBError: unique constraint violated)
```

#### `value` and `exception`

Use `value` for unlifting a `Success` and `exception` for getting error object from a `Failure`.

#### `to_either` and `to_maybe`

`Try`'s `Success` and `Failure` can be transformed to `Right` and `Left` correspondingly by calling `to_either` and to `Some` and `None` by calling `to_maybe`. Keep in mind that by transforming `Try` to `Maybe` you loose information about an exception so be sure that you've processed the error before doing so.

### List monad

#### `bind`

Lifts a block/proc and runs it against each member of the list. The block must return a value coercible to a list. As in other monads if no block given the first argument will be treated as callable and used instead.

```ruby
require 'dry-monads'

M = Dry::Monads

M::List[1, 2].bind { |x| [x + 1] } # => List[2, 3]
M::List[1, 2].bind(-> x { [x, x + 1] }) # => List[1, 2, 2, 3]

M::List[1, nil].bind { |x| [x + 1] } # => error
```

#### `fmap`

Maps a block over the list. Acts as `Array#map`. As in other monads if no block given the first argument will be treated as callable and used instead.

```ruby
require 'dry-monads'

M = Dry::Monads

M::List[1, 2].fmap { |x| x + 1 } # => List[2, 3]
```

#### `value`

You always can unlift the result by calling `value`.

```ruby
require 'dry-monads'

M = Dry::Monads

M::List[1, 2].value # => [1, 2]
```

#### Concatenates

```ruby
require 'dry-monads'

M = Dry::Monads

M::List[1, 2] + M::List[3, 4] # => List[1, 2, 3, 4]
```

#### `head` and `tail`

`head` returns the first element wrapped with a `Maybe`.

```ruby
require 'dry-monads'

M = Dry::Monads

M::List[1, 2, 3, 4].head # => Some(1)
M::List[1, 2, 3, 4].tail # => List[2, 3, 4]
```

#### `traverse`
Traverses the list with a block (or without it). This methods "flips" List structure with the given monad (obtained from the type).

**Note that traversing requires the list to be typed.**

```ruby
require 'dry-monads'

M = Dry::Monads

M::List[M::Right(1), M::Right(2)].typed(M::Either).traverse # => Right([1, 2])
M::List[M::Maybe(1), M::Maybe(nil), M::Maybe(3)].typed(M::Maybe).traverse # => None

# also, you can use fmap with #traverse

M::List[1, 2].fmap { |x| M::Right(x) }.typed(M::Either).traverse # => Right([1, 2])
M::List[1, nil, 3].fmap { |x| M::Maybe(x) }.typed(M::Maybe).traverse # => None
```

## Credits

`dry-monads` is inspired by Josep M. Bach’s [Kleisli](https://github.com/txus/kleisli) gem and its usage by [`dry-transactions`](http://dry-rb.org/gems/dry-transaction/) and [`dry-types`](http://dry-rb.org/gems/dry-types/).
