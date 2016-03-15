---
title: Macros
layout: gem-single
---

Rule composition using blocks is very flexible and powerful; however, in many common cases defining same rules all over again leads to boilerplate code. That's why `dry-validation` provides convenient macros available in the DSL to reduce that boilerplate. Every macro can be expanded to its block-based equivalent.

This document describes available built-in macros.

### required

Use it when a value is expected to be filled.

``` ruby
Dry::Validation.Schema do
  # expands to `key(:age) { filled? }`
  key(:age).required
end
```

``` ruby
Dry::Validation.Schema do
  # expands to `key(:age) { filled? & int? }`
  key(:age).required(:int?)
end
```

### maybe

Use it when a value can be nil.

``` ruby
Dry::Validation.Schema do
  # expands to `key(:age) { none? | int? }`
  key(:age).maybe(:int?)
end
```

### each

Use it to apply predicates to every element in a value that is expected to be an array.

``` ruby
Dry::Validation.Schema do
  # expands to: `key(:tags) { array? { each { str? } } }`
  key(:tags).each(:str?)
end
```

### when

Use it when another rule depends on the state of a value:

``` ruby
Dry::Validation.Schema do
  key(:email).maybe

  # expands to:
  #
  # rule(email: [:login]) { |login| login.true?.then(value(:email).filled?) }
  #
  key(:login).required(:bool?).when(:true?) do
    value(:email).filled?
  end
end
```

> Learn more about [high-level rules](/gems/dry-validation/high-level-rules)

### confirmation

Use it when another value under key with a `_confirmation` prefix is expected to be equal.

``` ruby
Dry::Validation.Schema do
  # expands to:
  #
  # rule(password_confirmation: [:password]) do |password|
  #   value(:password_confirmation).eql?(password) }
  # end
  #
  key(:password).required(min_size?: 12).confirmation
end
```
