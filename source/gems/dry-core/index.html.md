---
title: Introduction &amp; Usage
description: A toolset of small support modules used throughout the @dry-rb & @rom-rb ecosystems
layout: gem-single
order: 5
type: gem
name: dry-core
---

`dry-core` is a simple toolset that can be used in any places.

## Usage

### Cache
llows you to cache call results that are solely determined by arguments.

```ruby
require 'dry/core/cache'

class Foo
  extend Dry::Core::Cache

  def heavy_computation(arg1, arg2)
    fetch_or_store(arg1, arg2) { arg1 ^ arg2 }
  end
end
```

### Class Attributes

```ruby
require 'dry/core/class_attributes'

class MyClass
  extend Dry::Core::ClassAttributes

  defines :one, :two

  one 1
  two 2
end

class OtherClass < MyClass
  two 'two'
end

MyClass.one # => 1
MyClass.two # => 2

OtherClass.one # => 1
OtherClass.two # => 'two'
```

### Class Builder

```ruby
require 'dry/core/class_builder'

builder = Dry::Core::ClassBuilder.new(name: 'MyClass')

klass = builder.call
klass.name # => "MyClass"
```

### Constants
A list of constants you can use to avoid memory allocations or identity checks.

* `EMPTY_ARRAY`
* `EMPTY_HASH`
* `EMPTY_OPTS`
* `EMPTY_SET`
* `EMPTY_STRING`
* `Undefined` - A special value you can use as a default to know if no arguments were passed to you method

### Deprecations

```ruby
require 'dry/core/deprecations'

class Foo
  extend Dry::Core::Deprecations

  def self.old_class_api; end
  def self.new_class_api; end

  deprecate_class_method :old_class_api, :new_class_api

  def old_api; end
  def new_api; end

  deprecate_method :old_api, :new_api, "old_api is no-no"
end
```

### Extensions
Define extensions that can be later enabled by the user.

```ruby
require 'dry/core/extensions'

class Foo
  extend Dry::Core::Extensions

  register_extension(:bar) do
     def bar; :bar end
  end
end

Foo.new.bar # => NoMethodError
Foo.load_extensions(:bar)
Foo.new.bar # => :bar
```
