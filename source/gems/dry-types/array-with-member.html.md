---
title: Array With Member
layout: gem-single
---

The built-in array type supports defining member type:

``` ruby
PostStatuses = Types::Strict::Array.member(Types::Coercible::String)

PostStatuses[[:foo, :bar]] # ["foo", "bar"]
```
