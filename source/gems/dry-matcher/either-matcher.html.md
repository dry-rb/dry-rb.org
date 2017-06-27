---
title: Either matcher
layout: gem-single
name: dry-matcher
---

dry-matcher provides a ready-to-use `EitherMatcher` for working with `Either` or `Try` monads from [dry-monads](/gems/dry-monads) or any other compatible gems.

```ruby
require "dry-monads"
require "dry/matcher/either_matcher"

value = Dry::Monads::Either::Right.new("success!")

result = Dry::Matcher::EitherMatcher.(value) do |m|
  m.success do |v|
    "Yay: #{v}"
  end

  m.failure do |v|
    "Boo: #{v}"
  end
end

result # => "Yay: success!"
```
