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

