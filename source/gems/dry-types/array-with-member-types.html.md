---
title: Array With Member Types
layout: gem-single
name: types
order: 10
---

The built-in array type supports defining member type:

``` ruby
PostStatuses = Types::Strict::Array.member(Types::Coercible::String)

PostStatuses[[:foo, :bar]] # ["foo", "bar"]
```
