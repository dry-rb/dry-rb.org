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

CallableDateTime[nil]
# => #<DateTime: 2017-05-06T00:43:06+03:00 ((2457879j,78186s,649279000n),+10800s,2299161j)>
CallableDateTime[nil]
# => #<DateTime: 2017-05-06T00:43:07+03:00 ((2457879j,78187s,635494000n),+10800s,2299161j)>
```

It also receives the type constructor as an argument:

```ruby
CallableDateTime = Types::DateTime.constructor(&:to_datetime).default { |type| type[Time.now] }

CallableDateTime[Time.now]
# => #<DateTime: 2017-05-06T01:13:06+03:00 ((2457879j,79986s,63464000n),+10800s,2299161j)>
CallableDateTime[Date.today]
# => #<DateTime: 2017-05-06T00:00:00+00:00 ((2457880j,0s,0n),+0s,2299161j)>
CallableDateTime[nil]
# => #<DateTime: 2017-05-06T01:13:06+03:00 ((2457879j,79986s,63503000n),+10800s,2299161j)>
```

**WARNING**: If the value passed to the `.default` block does not match the type constraints, this will not throw an exception, because it not pass to the constructor and will be used as is.

```ruby
CallableDateTime = Types::DateTime.constructor(&:to_datetime).default { Time.now }

CallableDateTime[Time.now]
# => #<DateTime: 2017-05-06T00:50:09+03:00 ((2457879j,78609s,839588000n),+10800s,2299161j)>
CallableDateTime[Date.today]
# => #<DateTime: 2017-05-06T00:00:00+00:00 ((2457880j,0s,0n),+0s,2299161j)>
CallableDateTime[nil]
# => 2017-05-06 00:50:15 +0300
```
