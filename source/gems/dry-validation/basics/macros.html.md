---
title: Macros
layout: gem-single
---

Rule composition using blocks is very flexible and powerful; however, in many common cases defining same rules all over again leads to boilerplate code. That's why `dry-validation` provides convenient macros available in the DSL to reduce that boilerplate. Every macro can be expanded to its block-based equivalent.

This document describes available built-in macros.

### value

Use it to build up predicates.

```
Dry::Validation.Schema do
  # expands to `required(:age) { filled? & int? & gt?(3) }`
  required(:age).value(:filled?, :int?, gt?: 3)
end
```

### filled

Use it when a value is expected to be filled.

``` ruby
Dry::Validation.Schema do
  # expands to `required(:age) { filled? }`
  required(:age).filled
end
```

``` ruby
Dry::Validation.Schema do
  # expands to `required(:age) { filled? & int? }`
  required(:age).filled(:int?)
end
```

### maybe

Use it when a value can be nil.

``` ruby
Dry::Validation.Schema do
  # expands to `required(:age) { none? | int? }`
  required(:age).maybe(:int?)
end
```

### each

Use it to apply predicates to every element in a value that is expected to be an array.

``` ruby
Dry::Validation.Schema do
  # expands to: `required(:tags) { array? { each { str? } } }`
  required(:tags).each(:str?)
end
```

### when

Use it when another rule depends on the state of a value:

``` ruby
Dry::Validation.Schema do
  required(:email).maybe

  # expands to:
  #
  # rule(email: [:login]) { |login| login.true?.then(value(:email).filled?) }
  #
  required(:login).filled(:bool?).when(:true?) do
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
  required(:password).filled(min_size?: 12).confirmation
end
```
