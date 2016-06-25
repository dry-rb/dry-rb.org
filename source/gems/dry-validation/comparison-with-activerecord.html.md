---
title: Comparison With ActiveRecord
layout: gem-single
order: 10
---

As explained in the [introduction](/gems/dry-validation) Dry-Validation focuses on explicitness, clarity and preciseness of validation logic. For those of us used to ActiveRecord validations with their numerous options, ifs, ons and unlesses Dry-Validation is a way to make even the most complex validation cases easy to read and understand.

But, how would we go about converting our Active Record validation code into Dry-Validation?

After reading this guide, you will know:

- How to use dry-validation to replace built-in Active Record validation helpers.
- How to use dry-validation to create your own custom validation methods.

## 1. Validation Overview

When using ActiveRecord validation, validations are declared in the model in the following format:

`validates :name, :email, presence: true`

When using Dry-Validation, you declare your validation in a separate schema class using predicates to build up rules.

A predicate is a simple stateless method which receives some input and returns either `true` or `false`.

For example:

```ruby
Dry::Validation::Schema do
  key(:email).required
  key(:name).required
end
```

## 2. Validation Helpers

### 2.1 acceptance

In ActiveRecord validations this helper is used to validate that a checkbox on the user interface was checked when a form was submitted. This is typically used when the user needs to agree to your application's terms of service, confirm reading some text, or any similar concept.

In its simplest form:

**ActiveRecord Validation**

```ruby
validates :attr, acceptance: true
```

**Dry Validation**

```ruby
key(:attr) { bool? & true? }
```

When using the `:accepts` option:

**ActiveRecord Validation**

```ruby
validates :attr, acceptance: { accept: 'yes' }
```

**Dry Validation**

```ruby
key(:attr).required(eql?: 'yes')
```

> Note: ActiveRecord automatically creates a virtual acceptance attribute for you. If you are using Protected Parameters you will need to add this attribute yourself.

### 2.2 validates_associated

You will need to create a custom predicate to achieve this.

**Unsure if you can access the object & its associated objects in dry-v**

### 2.3 confirmation

This helper is used when you have two text fields that should receive exactly the same content. Common use cases include email addresses and passwords.


**ActiveRecord Validation**

```ruby
validates :attr, confirmation: true
```

**Dry Validation**

```ruby
key(:attr).confirmation
```

> Note: In these examples, checks are performed only if attr_confirmation is not nil. To require confirmation, make sure to add a presence check for the confirmation attribute:

**ActiveRecord Validation**

```ruby
validates :attr, confirmation: true
validates :attr_confirmation, presence: true
```

**Dry Validation**

```ruby
key(:attr).required.confirmation
```

> Note: ActiveRecord automatically creates a virtual confirmation attribute for you whose name is the name of the field that has to be confirmed with "_confirmation" appended. If you are using Protected Parameters you will need to add this attribute yourself.

### 2.4 exclusion

This helper validates that the attributes' values are not included in a given enumerable object.

**ActiveRecord Validation**

```ruby
validates :attr, exclusion: { in: enumerable_object }
```

**Dry Validation**

```ruby
key(:attr).required(exclusion?: enumerable_object)
```

> Note: As per ActiveRecord docs, `:within` option is an alias of `:in`

### 2.5 format

This helper validates the attributes' values by testing whether they match or doesn't match a given regular expression.

####Match

**ActiveRecord Validation**

```ruby
validates :attr, format: { with: regex }
```

**Dry Validation**

```ruby
key(:attr).required(format?: regex)
```

####Doesn't Match

**ActiveRecord Validation**

```ruby
validates :attr, format: { without: regex }
```

**Dry Validation**

```ruby
key(:attr) { filled? & !format?(regex) }
```

### 2.6 inclusion

This helper validates that the attributes' values are included in a given enumerable object.

**ActiveRecord Validation**

```ruby
validates :attr, inclusion: { in: enumerable_object }
```

**Dry Validation**

```ruby
key(:attr).required(inclusion?: enumerable_object)
```

> Note: As per ActiveRecord docs, `:within` option is an alias of `:in`

### 2.7 length

This helper validates the length of the attributes' values. ActiveRecord relies on a variety of options to specify length constraints in different ways. Dry-Validation uses different predicates for each constraint.

####Minimum

**ActiveRecord Validation**

```ruby
validates :attr, length: { minimum: int }
```

**Dry Validation**

```ruby
key(:attr).required(min_size?: int)
```

####Maximum

**ActiveRecord Validation**

```ruby
validates :attr, length: { maximum: int }
```

**Dry Validation**

```ruby
key(:attr).required(max_size?: int)
```

####In

**ActiveRecord Validation**

```ruby
validates :attr, length: { in: range }
```

**Dry Validation**

```ruby
key(:attr).required(size?: range)
```

####Is

**ActiveRecord Validation**

```ruby
validates :attr, length: { is: int }
```

**Dry Validation**

```ruby
key(:attr).required(size?: int)
```

####Tokeniser Option

As with Active Record Validations, Dry-Validation counts characters by default. ActiveRecord provides a `:tokeniser` option to allow you to customise how the value is split. You can acheive the same thing in Dry-Validation by creating your own predicate.

E.g.:

```ruby
Dry::Validation.Schema do
  key(:attr).{ filled? & word_count?(min_size: 300, max_size: 400) }

  configure do
    def word_count?(value, options={})
      words = value.split(/\s+/).size #split into seperate words
      words >= options[:min_size] && words <= options[:max_size] #compare no. words with parameters
    end
  end
end

````

### 2.8 numericality
Active Record determines numericality either by trying to convert the value to a number using Float, or using a Regex if you specify `only_integer: true`.

In Dry Validation, you can either validate by data type using the build in type predicates  `.int?` `.float?` and `.decimal?` or define a custom predicate to test if the value is a number regardless of data type.

You could use the predicate below to achieve this. Copied from rails 'activemodel/lib/active_model/validations/numericality.rb', line 58

**ActiveRecord Validation**

```ruby
validates :attr, numericality: true
```

**Dry Validation**

```ruby
Dry::Validation.Schema do
  #if you know what type of number you require then simply use one of the options below:
  key(:attr).required(:int?)
  key(:attr).required(:float?)
  key(:attr).required(:decimal?)


  #For anything which represents a number (e.g. '1', 15, '12.345' etc.)
  #you can simply use:
  key(:attr).required(:number?)
end
```

For validations using additional options (`:greater_than`, `:less_than` etc.) you should use the correct type `.int?`, `.float?`, `.decimal?` rather than the custom predicate above.

####Options - only_integer

**ActiveRecord Validation**

```ruby
validates :attr, numericality: { only_integer: true }
```

**Dry Validation**

```ruby
key(:attr).required(format?: /\A[+-]?\d+\Z/) #option 1 - most similar to ActiveRecord
key(:attr).required(:int?) #option 2 - best practise
```

####Options - greater_than

**ActiveRecord Validation**

```ruby
validates :attr, numericality: { greater_than: int }
```

**Dry Validation**

```ruby
key(:attr).required(:int?, gt?: int)
```
####Options - greater_than_or_equal_to

**ActiveRecord Validation**

```ruby
validates :attr, numericality: { greater_than_or_equal_to: int }
```

**Dry Validation**

```ruby
key(:attr).required(:int?, gteq?: int)
```

####Options - less_than

**ActiveRecord Validation**

```ruby
validates :attr, numericality: { less_than: int }
```

**Dry Validation**

```ruby
key(:attr).required(:int?, lt?: int)
```

####Options - less_than_or_equal_to

**ActiveRecord Validation**

```ruby
validates :attr, numericality: { less_than_or_equal_to: int }
```

**Dry Validation**

```ruby
key(:attr).required(:int?, lteq?: int)
```

####Options - equal_to

**ActiveRecord Validation**

```ruby
validates :attr, numericality: { equal_to: int }
```

**Dry Validation**

```ruby
key(:attr).required(:int?, eq?: int)
```

####Options - odd

**ActiveRecord Validation**

```ruby
validates :attr, numericality: { odd: true }
```

**Dry Validation**

```ruby
Dry::Validation.Schema do
  key(:attr){ int? & odd? }
end

```

####Options - even

**ActiveRecord Validation**

```ruby
validates :attr, numericality: { even: true }
```

**Dry Validation**

```ruby
Dry::Validation.Schema do
  key(:attr).required(:int?, :even?)
end
```

> Note: `odd?` and `even?` predicates can only be used on integers.


####Additional Uses:

Because dry validations uses equality operators (`<`, `>`, `==` etc.) for its predicates they can be used to validate anything which comparable.

For example you can use these predicates to validate dates straight out of the box:

```ruby
key(:attr).required(:date?, lteq?: start_date, gteq?: end_date)
```

### 2.9 presence

**ActiveRecord Validation**

```ruby
validates :attr, presence: true
```

**Dry Validation**

```ruby
key(:attr).required
```

**Associations**

If you want to be sure that an association is present, you'll need to create a custom predicate to test whether the associated object itself is present.

If you want to replicate Active Record's presence validation of an object associated via a has_one or has_many relationship (checking `.blank?` and `.marked_for_destruction?`), you will need a custom predicate.

**Booleans**

If you want to validate the presence of a boolean field (e.g. true or false) you should use the built in predicate `.bool?`.

```ruby
key(:attr).required(:bool?)
```

### 2.10 absence

**ActiveRecord Validation**
```ruby
validates :attr, absence: true
```

**Dry Validation**
Dry validation includes two predicates (`empty?` and `none?`) for absense. You should use whichever is most applicable to your circumstance remembering that an empty string can be turned into nil when using to_nil coercion.

```ruby
key(:attr) { none? } # only allows nil
key(:attr) { empty? } # only empties:  string(```""```), array(```[]```), hash(```{}```) etc
```

####Associations

If you want to be sure that an association is absent, you'll need create a custom predicate to test whether the associated object itself is absent.

> TODO: give an example of what such a predicate could looklike

**Booleans**

To validate the absence of a boolean field (e.g. not true or false) you should use:

```ruby
key(:attr) { exclusion?([true, false]) }
```

### 2.11 uniqueness

ToDo

### 2.12 validates_with

ToDo

### 2.13 validates_each

ToDo

### 3. Common Validation Options

These are the common options allowed by ActiveRecord validations and their equivalents in Dry Validation

####3.1 `:allow_nil`

In Dry-Validation you can simply use `maybe` instead of `required` when defining your rules.

**ActiveRecord Validation**

```ruby
validates :attr, length: { minimum: int, allow_nil: true }
```

**Dry Validation**

```ruby
key(:attr).maybe(int?, min_size?: int)
```

####3.2  `:allow_blank`

In Dry-Validation you will need to use a block when defining your rule instead of `required` and include the `.empty?` predicate into your rule.


**ActiveRecord Validation**

```ruby
validates :attr, length: { minimum: int, allow_blank: true }
```

**Dry Validation**

```ruby
key(:attr) { empty? | int? & min_size?: int )
```

####3.3 `:message`

Custom messages are implemented through a separate yaml file see the [error messages page](/gems/dry-validation/error-messages/) for full instructions.

####3.4 `:on`

In Dry-Validation, validations are defined in schemas. You can create seperate schemas for various states (e.g UserCreateSchema, UserUpdateSchema) and then choose the correct schema to run in the relevant action.

You can keep your schema code nice and DRY by [reusing schemas](gems/dry-validation/reusing-schemas/).

### 4. Conditional Validation

In Active Record you can use `:if` or `:unless` to only perform a validation based on the result of a proc or method.

For example:

```ruby
validates :card_number, presence: true, if: :paid_with_card?

def paid_with_card?
  payment_type == "card"
end
```

To achieve this in Dry Validation you can use [high-level rules](/gems/dry-validation/high-level-rules/).

.1. Initially we declare a rule for each of the attributes we need to reference
```ruby
key(:payment_type).required(inclusion?: ["card", "cash", "cheque"])
key(:card_number).maybe
```

.2. Declare a custom predicate to check if `payment_type == 'card'`

```ruby
def paid_with_card?(value)
  value == "card"
end
```

.3. Declare a high level rule to require the card number if `payment_type == 'card'`
```ruby
rule(require_card_number: [:card_number, :payment_type]) do |card_number, payment_type|
  payment_type.paid_with_card? > card_number.filled?
end

```

Put it all together and you get:
```ruby
Dry::Validation.Schema do
  key(:payment_type).required(inclusion?: ["card", "cash", "cheque"])
  key(:card_number).maybe

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
