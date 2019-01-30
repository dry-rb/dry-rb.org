---
title: Macros
layout: gem-single
name: dry-schema
---

Rule composition using blocks is very flexible and powerful; however, in many common cases repeatedly defining the same rules leads to boilerplate code. That's why `dry-schema`'s DSL provides convenient macros to reduce that boilerplate. Every macro can be expanded to its block-based equivalent.

This document describes available built-in macros.

### value

Use it to quickly provide a list of all predicates that will be `AND`-ed automatically:

```ruby
Dry::Schema.Params do
  # expands to `required(:age) { int? & gt?(18) }`
  required(:age).value(:integer, :int?, gt?: 18)
end
```

### filled

Use it when a value is expected to be filled. "filled" means that the value is non-nil and, in the case of a `String`, `Hash`, or `Array` value, that the value is not `.empty?`.

```ruby
Dry::Schema.Params do
  # expands to `required(:age) { filled? }`
  required(:age).filled
end
```

```ruby
Dry::Schema.Params do
  # expands to `required(:age) { array? & filled? }`
  required(:tags).filled(:array)
end
```

### maybe

Use it when a value can be nil.

```ruby
Dry::Schema.Params do
  # expands to `required(:age) { !nil?.then(int?) }`
  required(:age).maybe(:integer)
end
```

### each

Use it to apply predicates to every element in a value that is expected to be an array.

```ruby
Dry::Schema.Params do
  # expands to: `required(:tags) { each { str? } } }`
  required(:tags).value(:array?).each(:str?)
end
```
