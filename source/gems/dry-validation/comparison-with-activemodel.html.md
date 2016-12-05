---
title: Comparison With ActiveModel
layout: gem-single
order: 10
---

As explained in the [introduction](/gems/dry-validation), dry-validation focuses on explicitness, clarity and precision of validation logic. For those of us used to ActiveModel validations with their numerous options, ifs, ons and unlesses, dry-validation is a way to make even the most complex validation cases easy to read and understand.

But, how would we go about converting our ActiveModel validation code into dry-validation?

After reading this guide, you will know:

- How to use dry-validation to replace built-in ActiveModel validation helpers.
- How to use dry-validation to create your own custom validation methods.

> Note that there isn't a one-to-one correspondence between ActiveModel validators and Dry predicates.

> For the main documentation on dry-validation predicates, see [Built-in Predicates](http://dry-rb.org/gems/dry-validation/basics/built-in-predicates/).

## 1. Validation Overview

When using ActiveModel validation, validations are declared in the model in the following format:

`validates :name, :email, presence: true`

You then update the model's state and call `valid?` on the model to see if the state is correct.  (In the opinion of the dry-rb team, this is a design flaw of ActiveModel. See [this blog post](http://solnic.eu/2015/12/28/invalid-object-is-an-anti-pattern.html]) for more information).

When using dry-validation, you declare your validation in a separate schema class using predicates to build up rules.

A predicate is a simple stateless method which receives some input and returns either `true` or `false`.

A simple schema can look like this:

```ruby
schema = Dry::Validation.Schema do
  required(:email).filled
  required(:name).filled
end
```

## 2. Validation Helpers

### 2.1 acceptance

In ActiveModel validations this helper is used to validate that a checkbox on the user interface was checked when a form was submitted. This is typically used when the user needs to agree to your application's terms of service, confirm reading some text, or any similar concept.

In its simplest form:

**ActiveModel Validation**

```ruby
validates :attr, acceptance: true
```

**dry-validation**

```ruby
required(:attr) { bool? & true? }
```

When using the `:accepts` option:

**ActiveModel Validation**

```ruby
validates :attr, acceptance: { accept: 'yes' }
```

**dry-validation**

```ruby
required(:attr).filled(eql?: 'yes')
```

> Note: ActiveModel automatically creates a virtual acceptance attribute for you. If you are using Protected Parameters you will need to add this attribute yourself.

### 2.2 validates_associated

You will need to create a custom predicate to achieve this.

TODO expand

### 2.3 confirmation

This helper is used when you have two text fields that should receive exactly the same content. Common use cases include email addresses and passwords.

**ActiveModel Validation**

```ruby
validates :attr, confirmation: true
```

**dry-validation**

```ruby
required(:attr).confirmation
```

> Note: ActiveModel automatically creates a virtual confirmation attribute for you whose name is the name of the field that has to be confirmed with "_confirmation" appended. If you are using Protected Parameters you will need to add this attribute yourself.

### 2.4 exclusion

This helper validates that the attributes' values are not included in a given enumerable object.

**ActiveModel Validation**

```ruby
validates :attr, exclusion: { in: enumerable_object }
```

**dry-validation**

```ruby
required(:attr).filled(excluded_from?: enumerable_object)
```

> Note: As per ActiveModel docs, `:within` option is an alias of `:in`

### 2.5 format

This helper validates the attributes' values by testing whether they match or doesn't match a given regular expression.

**ActiveModel Validation**

```ruby
validates :attr, format: { with: regex }
```

**dry-validation**

```ruby
required(:attr).required(format?: regex)
```

####Doesn't Match

**ActiveModel Validation**

```ruby
validates :attr, format: { without: regex }
```

**dry-validation**

```ruby
required(:attr) { filled? & format?(regex).not }
```

### 2.6 inclusion

This helper validates that the attributes' values are included in a given enumerable object.

**ActiveModel Validation**

```ruby
validates :attr, inclusion: { in: enumerable_object }
```

**dry-validation**

```ruby
required(:attr).filled(included_in?: enumerable_object)
```

> Note: As per ActiveModel docs, `:within` option is an alias of `:in`

### 2.7 length

This helper validates the length of the attribute's value. ActiveModel relies on a variety of options to specify length constraints in different ways. dry-validation uses different predicates for each constraint.

#### Minimum

**ActiveModel Validation**

```ruby
validates :attr, length: { minimum: int }
```

**dry-validation**

```ruby
required(:attr).filled(min_size?: int)
```

####Maximum

**ActiveModel Validation**

```ruby
validates :attr, length: { maximum: int }
```

**dry-validation**

```ruby
required(:attr).filled(max_size?: int)
```

####In

**ActiveModel Validation**

```ruby
validates :attr, length: { in: range }
```

**dry-validation**

```ruby
required(:attr).filled(size?: range)
```

####Is

**ActiveModel Validation**

```ruby
validates :attr, length: { is: int }
```

**dry-validation**

```ruby
required(:attr).filled(size?: int)
```

#### Tokeniser Option

As with ActiveModel Validations, dry-validation counts characters by default. ActiveModel provides a `:tokeniser` option to allow you to customise how the value is split. You can achieve the same thing in dry-validation by creating your own predicate, e.g.:

```ruby
Dry::Validation.Schema do
  required(:attr).filled { word_count?(min_size: 300, max_size: 400) }

  configure do
    def word_count?(options={}, value)
      words = value.split(/\s+/).size #split into seperate words
      words >= options[:min_size] && words <= options[:max_size] # compare no. words with parameters
    end
  end
end
```

### 2.8 numericality

ActiveModel determines numericality either by trying to convert the value to a Float, or by using a Regex if you specify `only_integer: true`.

In dry-validation, you can either validate that the value is of type Integer, Float, or Decimal using the `.int?`, `.float?` and `.decimal?` predicates respectively, or you can use `number?` to test if the value is numerical regardless of its specific data type.

**ActiveModel Validation**

```ruby
validates :attr, numericality: true
```

**dry-validation**

```ruby
Dry::Validation.Schema do
  # if you know what type of number you require then simply use one of the options below:
  required(:attr).filled(:int?)
  required(:attr).filled(:float?)
  required(:attr).filled(:decimal?)

  # For anything which represents a number (e.g. '1', 15, '12.345' etc.)
  # you can simply use:
  required(:attr).filled(:number?)
end
```

For validations using additional options (`:greater_than`, `:less_than` etc.) you should use the correct type (`.int?`, `.float?`, `.decimal?`) rather than the custom predicate above.

For validations using additional options (`:greater_than`, `:less_than` etc.) you should use the correct type `.int?`, `.float?`, `.decimal?` rather than the custom predicate above.

#### Options - only_integer

**ActiveModel Validation**

```ruby
validates :attr, numericality: { only_integer: true }
```

**dry-validation**

```ruby
required(:attr).filled(format?: /\A[+-]?\d+\Z/) #option 1 - most similar to ActiveModel
required(:attr).filled(:int?) #option 2 - best practise
```

#### Options - greater_than

**ActiveModel Validation**

```ruby
validates :attr, numericality: { greater_than: int }
```

**dry-validation**

```ruby
required(:attr).filled(:int?, gt?: int)
```

#### Options - greater_than_or_equal_to

**ActiveModel Validation**

```ruby
validates :attr, numericality: { greater_than_or_equal_to: int }
```

**dry-validation**

```ruby
required(:attr).filled(:int?, gteq?: int)
```

#### Options - less_than

**ActiveModel Validation**

```ruby
validates :attr, numericality: { less_than: int }
```

**dry-validation**

```ruby
required(:attr).filled(:int?, lt?: int)
```

#### Options - less_than_or_equal_to

**ActiveModel Validation**

```ruby
validates :attr, numericality: { less_than_or_equal_to: int }
```

**dry-validation**

```ruby
required(:attr).filled(:int?, lteq?: int)
```

#### Options - equal_to

**ActiveModel Validation**

```ruby
validates :attr, numericality: { equal_to: int }
```

**dry-validation**

```ruby
required(:attr).filled(:int?, eq?: int)
```

#### Options - odd

**ActiveModel Validation**

```ruby
validates :attr, numericality: { odd: true }
```

**dry-validation**

```ruby
Dry::Validation.Schema do
  required(:attr).filled(:int?, :odd?)
end
```

#### Options - even

**ActiveModel Validation**

```ruby
validates :attr, numericality: { even: true }
```

**dry-validation**

```ruby
Dry::Validation.Schema do
  required(:attr).filled(:int?, :even?)
end
```

> Note: `odd?` and `even?` predicates can only be used on integers.

**Additional Uses:**

dry-validation's predicates uses basic Ruby equality operators (`<`, `>`, `==` etc.) which means that they can be used to validate anything that's comparable.

For example you can use these predicates to validate dates straight out of the box:

```ruby
required(:attr).filled(:date?, lteq?: start_date, gteq?: end_date)
```

### 2.9 presence

dry-validation has no exact equivalent of ActiveModel's `presence` validation, as in `validates :attr, presence: true`. A first approximation would be `required(:attr).filled`; however there are a few differences.

Internally, ActiveModel's `presence` validation calls the method `present?` on the validated attribute, which is equivalent to `!blank?`. Neither `present?` nor `blank?` are a inbuilt Ruby methods, but a monkey-patch added to every object by ActiveSupport, with the following semantics:

- `nil` and `false` are blank
- strings composed only of whitespace are blank
- empty arrays and hashes are blank
- any object that responds to `empty?` and is empty is blank.
- everything else is present.

dry-validation's `filled?` predicate is simpler than this, and considers everything to be filled except `nil`, empty Strings, empty Arrays, and empty Hashes.

If you want to validate that a string key contains non-whitespace characters (like ActiveSupport's `String#present?`, you can use a custom predicate such as:

```ruby
WHITESPACE_PATTERN = /\A[[:space:]#{"\u200B\u200C\u200D\u2060\uFEFF"}]*\z/

def non_blank?(input)
  !(WHITESPACE_PATTERN =~ input)
end
```

**Associations**

If you want to be sure that an association is present, you'll need to create a custom predicate to test whether the associated object itself is present.

If you want to replicate ActiveModel's presence validation of an object associated via a has_one or has_many relationship (checking `.blank?` and `.marked_for_destruction?`), you will need a custom predicate.

**Booleans**

If you want to validate the presence of a boolean field (e.g. true or false) you should use the built in predicate `.bool?`.
E.g. `required(:attr).filled(:bool?)`

### 2.10 absence

**ActiveModel Validation**

```ruby
validates :attr, absence: true
```

**dry-validation**

Dry validation includes two predicates (`empty?` and `none?`) for absence. You should use whichever is most applicable to your situation, remembering that an empty string can be turned into nil using `to_nil` coercion.

```ruby
required(:attr).filled(:none?)  # only allows nil
required(:attr).filled(:empty?) # only empty values:  "", [], {}, or nil
```

####Associations

If you want to be sure that an association is absent, you'll need create a custom predicate to test whether the associated object itself is absent.

> TODO: give an example of what such a predicate could looklike

**Booleans**

To validate the absence of a boolean field (e.g. not true or false) you should use:

```ruby
required(:attr).filled(excluded_from?: [true, false])
```

**Booleans**

To validate the absence of a boolean field (e.g. not true or false) you should use:

`required(:attr).filled(:none?)`

### 2.11 uniqueness

Rails' `uniqueness` validation is fundamentally different from the other validations because it requires a query against a database. (Accordingly, the uniqueness validation is contained within the `activerecord` gem, while other validations are part of `activemodel`.) TODO does this mean that dry-v can't handle this case? expand

### 2.12 validates_with

TODO expand

### 2.13 validates_each

TODO expand

### 3. Common Validation Options

These are the common options allowed by ActiveModel validations, and their equivalents in dry-validation

**3.1 `:allow_nil`**

Simply use `maybe` instead of `required` when defining your rules.

**ActiveModel Validation**

```ruby
validates :attr, length: { minimum: int, allow_nil: true }
```

**dry-validation**

```ruby
required(:attr).filled(int?, min_size?: int)
```

**3.2  `:allow_blank`**

In dry-validation you will need to use a block when defining your rule instead of `filled`, and include the `.empty?` predicate into your rule.

**ActiveModel Validation**

```ruby
validates :attr, length: { minimum: int, allow_blank: true }
```

**dry-validation**

```ruby
required(:attr) { empty? | int? & min_size?: int )
```


**3.3 `:message`**

Custom messages are implemented through a separate YAMl file. See [Error Messages](http://dry-rb.org/gems/dry-validation/error-messages/) for full instructions.

**3.4 `:on`**

In dry-validation, validations are defined in schemas. You can create separate schemas for various states (e.g UserCreateSchema, UserUpdateSchema) and then choose the correct schema to run in the relevant action.

You can keep your schema code nice and DRY by [reusing schemas](gems/dry-validation/reusing-schemas/).

### 4. Conditional Validation
In ActiveModel you can use `:if` or `:unless` to only perform a validation based on the result of a proc or method.

A simple schema can look like this:

```ruby
validates :card_number, presence: true, if: :paid_with_card?

def paid_with_card?
  payment_type == "card"
end
```

To achieve this in dry-validation you can use [high-level rules](/gems/dry-validation/high-level-rules/).

.1. Declare a rule for each of the attributes you need to reference:

```ruby
required(:payment_type).filled(included_in?: ["card", "cash", "cheque"])
required(:card_number).maybe
```

.2. Declare a custom predicate to check if `payment_type == 'card'`:

```ruby
def paid_with_card?(value)
  value == "card"
end
```

.3. Declare a high level rule to require the card number if `payment_type == 'card'`:

```ruby
rule(require_card_number: [:card_number, :payment_type]) do |card_number, payment_type|
  payment_type.paid_with_card? > card_number.filled?
end
```

Put it all together and you get:
```ruby
Dry::Validation.Schema do
  required(:payment_type).filled(included_in?: ["card", "cash", "cheque"])
  required(:card_number).maybe

  rule(require_card_number: [:card_number, :payment_type]) do |card_number, payment_type|
    payment_type.paid_with_card? > card_number.filled?
  end

  configure do
    def paid_with_card?(value)
      value == "card"
    end
  end
end
```
