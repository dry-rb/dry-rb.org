---
title: High-level Rules
layout: gem-single
order: 6
group: dry-validation
---

## Rules Depending On Results From Other Rules

It is often not enough to define simple type-checking rules and in addition to those you need to be able to specify higher-level rules that simply rely on other rules. This can be achieved using `rule` interface which can access already defined rules for specific keys.

In example let's say we have a schema with 3 keys, `:barcode`, `:job_number` and `:sample_number` and we need to make sure that when barcode is provided then both job and sample numbers cannot be provided. The low-level checks need to make sure that individual values have correct state and on top of that we can define our high-level rule:

``` ruby
class BarcodeSchema < Dry::Validation::Schema
  key(:barcode) do |barcode|
    barcode.none? | barcode.filled?
  end

  key(:job_number) do |job_number|
    job_number.none? | job_number.int?
  end

  key(:sample_number) do |sample_number|
    sample_number.none? | sample_number.int?
  end

  rule(:barcode_only) do
    rule(:barcode).filled? & (rule(:job_number).none? & rule(:sample_number).none?)
  end
end
```

This way we have validations for individual keys and the high-level `:barcode_only` rule which says "barcode can be filled only if both job_number and sample_number are empty".

## Rules Depending On Values From Other Rules

Similar to rules that depend on results from other rules, you can define high-level rules that need to apply additional predicates to values provided by other rules. In example, let's say we want to validate presence of an `email` address but only when `login` value is set to `true`:

``` ruby
class UserSchema < Dry::Validation::Schema
  key(:login) { |login| login.bool? }
  key(:email) { |email| email.none? | email.filled? }

  rule(:email_presence) do
    value(:login).true? > rule(:email).filled?
  end
end
```

This translates to "login set to true implies that email must be present".

We can also easily specify a rule for the absence of an email:

``` ruby
class UserSchema < Dry::Validation::Schema
  key(:login) { |login| login.bool? }
  key(:email) { |email| email.none? | email.filled? }

  rule(:email_absence) do
    value(:login).false? > rule(:email).none?
  end
end
```

## Rules Depending On Many Values

When a rule needs input from other rules and depends on their results you can
define it using `rule` DSL. A common example of this is "confirmation validation":

``` ruby
class Schema < Dry::Validation::Schema
  key(:password, &:filled?)
  key(:password_confirmation, &:filled?)

  rule(:password_confirmation, eql?: [:password, :password_confirmation])
end
```

A short version of the same thing:

``` ruby
class Schema < Dry::Validation::Schema
  confirmation(:password)
end
```

Notice that you must add `:password_confirmation` error message configuration if
you want to have the error converted to a message.
