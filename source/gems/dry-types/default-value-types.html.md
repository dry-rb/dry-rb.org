---
title: Default-Value Types
layout: gem-single
name: types
order: 5
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
