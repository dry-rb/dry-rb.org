---
title: Default Values
layout: gem-single
---

A type with a default value will return the configured value when the input is `nil`:

``` ruby
PostStatus = Types::Strict::String.default('draft')

PostStatus[nil] # "draft"
PostStatus["published"] # "published"
PostStatus[true] # raises ConstraintError
```

It respects type coercions too:

``` ruby
PostStatus = Types::Form::String.default('draft')

# this works because an empty string in `form` category is coerced to `nil`
PostStatus[''] # "draft"
PostStatus["published"] # "published"
```

It works with a callable value:

``` ruby
CallableDateTime = Types::DateTime.default { DateTime.now }

CallableDateTime[nil] # Sun, 07 Aug 2016 23:52:04 -0400
CallableDateTime[nil] # Sun, 07 Aug 2016 23:52:05 -0400
```

**Be careful:** types will return the **same instance** of the default value every time. This may cause problems if you mutate the returned value after receiving it:

```ruby
default_0 = PostStatus.(nil)
# => "draft"
default_1 = PostStatus.(nil)
# => "draft"

# Both variables point to the same string:
default_0.object_id == default_1.object_id
# => true

# Mutating the string will change the default value of type:
default_0 << '_mutated'
PostStatus.(nil)
# => "draft_mutated" # not "draft"
```

You can guard against these kind of errors by calling `freeze` when setting the default:

```ruby
PostStatus = Types::Form::String.default('draft'.freeze)
default = PostStatus.(nil)
default << 'attempt to mutate default'
# => RuntimeError: can't modify frozen string

# If you really want to mutate it, call `dup` on it first:
default = default.dup
default << "this time it'll work"
```
