---
title: Introduction & Usage
description: Expressive match API for operating on Either results
layout: gem-single
type: gem
---

## Introduction

`dry-result_matcher` is an expressive, all-in-one API for operating on [Kleisli](https://github.com/txus/kleisli) `Either` results.

It’s particularly useful for controlling flow using your `Either` results from within a heavily block-based DSL, like the [Roda](http://roda.jeremyevans.net) routing tree.

## Usage

Operate an an `Either` object from the outside:

```ruby
result = Right("some result")

Dry::ResultMatcher.match(result) do |m|
  m.success do |v|
    "Success: #{v}"
  end

  m.failure do |v|
    "Failure: #{v}"
  end
end
```

Or extend your own `Either`-returning classes to support result match blocks:

```ruby
class MyOperation
  include Dry::ResultMatcher.for(:call)

  def call
    Right("some result")
  end
end

my_op = MyOperation.new
my_op.call() do |m|
  m.success do |v|
    "Success: #{v}"
  end

  m.failure do |v|
    "Failure: #{v}"
  end
end
```
