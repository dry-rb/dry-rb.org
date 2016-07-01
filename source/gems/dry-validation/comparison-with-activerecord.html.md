---
title: Comparison With ActiveRecord
layout: gem-single
order: 10
---

## 1. Validation Overview

When using ActiveRecord validation, you declare your validations in the model in the following format:

`validates :name, :email, presence: true`

When using Dry Validation, you declare your validation in a separate schema class using predicates to build up rules.
For example:

```ruby
require 'dry-validation'

class Schema < Dry::Validation::Schema
  required(:email) { |email| email.filled? }
  required(:name) { |name| name.filled? }
end
```
or the short-hand:

```ruby
require 'dry-validation'

class Schema < Dry::Validation::Schema
  required(:email, &:filled?)
  required(:name, &:filled?)
end
```
You can declare multiple predicates per key (or attribute) for example

Active Record: `validates :email, presence: true, format: { with: EMAIL_REGEX }`

Dry Validation: ` required(:email) { |email| email.filled? & email.format?(EMAIL_REGEX) }`

## 2. Validation Helpers

### 2.1 acceptance

| Active Record Validation                         | Dry Validation                         |
|--------------------------------------------------|----------------------------------------|
| `validates :attr, acceptance: true`              | `required(:attr){ |attr| attr.eql?('1') }`  |
| `validates :attr, acceptance: { accept: 'yes' }` | `required(:attr){ |attr| attr.eql?('yes') }`|

Note: Active Record automatically creates the virtual acceptance attribute for you, so you will need to do this manually.

### 2.2 validates_associated

You will need to create a custom predicate to achieve this.

**Unsure if you can access the object & its associated objects in dry-v**

### 2.3 confirmation
| Active Record Validation              | Dry Validation        |
|---------------------------------------|-----------------------|
| `validates :attr, confirmation: true` | `confirmation(:attr)` |

> Note: Active Record automatically creates the virtual confirmation attribute for you, so you will need to do this manually.

> If using in combination with `:allow_nil` or `:allow_blank` options you will need to create your own rules instead of using the above dry validation helper.

### 2.4 exclusion
| Active Record Validation                    | Dry Validation                               |
|---------------------------------------------|----------------------------------------------|
| `validates :attr, exclusion: { in: array }` | `required(:attr){ |attr| attr.exclusion?(array) }`|

> Note: As per ActiveRecord docs, `:within` option is an alias of `:in`

### 2.5 format
| Active Record Validation                      | Dry Validation                               |
|-----------------------------------------------|----------------------------------------------|
| `validates :attr, format: { with: regex }`    | `required(:attr) { |attr| attr.format?(regex) }`  |
| `validates :attr, format: { without: regex }` | `required(:attr) { |attr| !attr.format?(regex) }` |

### 2.6 inclusion
| Active Record Validation                    | Dry Validation                                 |
|---------------------------------------------|------------------------------------------------|
| `validates :attr, inclusion: { in: array }` | `required(:attr) { |attr| attr.inclusion?(array) }` |

> Note: As per ActiveRecord docs, `:within` option is an alias of `:in`

### 2.7 Length
| Active Record                               | Dry Validation Predicate                    |
|---------------------------------------------|---------------------------------------------|
| `validates :attr, length: { minimum: int }` | `required(:attr) { |attr| attr.min_size?(int) }` |
| `validates :attr, length: { maximum: int }` | `required(:attr) { |attr| attr.max_size?(int) }` |
| `validates :attr, length: { in: range }`    | `required(:attr) { |attr| attr.size?(range) }`   |
| `validates :attr, length: { is: int }`      | `required(:attr) { |attr| attr.size?(int) }`     |

### 2.8 Numericality
Active Record determines numericality either by trying to convert the value to a number using Float, or using a Regex if you specify `only_integer: true`.

In Dry Validation, you can either validate by data type using the build in type predicates  `.int?` `.float?` and `.decimal?` or define a custom predicate to test if the value is a number regardless of data type.

You could use the predicate below to achieve this. Copied from rails 'activemodel/lib/active_model/validations/numericality.rb', line 58

```ruby
def value_is_a_number?(value)
  case value
  when %r\A0[xX]/
    false
  else
    begin
      Kernel.Float(value)
    rescue ArgumentError, TypeError
      false
    end
  end
end
```
The examples in the table below use the predicate example above, but you could use `.int?`, `.float?`, `.decimal?` in its place.

| Active Record                                                     | Dry Validation                                     |
|-------------------------------------------------------------------|----------------------------------------------------|
| `validates :name, numericality: true`                             | `required(:attr){ |attr| attr.value_is_a_number? }`     |
| `validates :attr, numericality: { only_integer: true }`           | `required(:attr){ |attr| attr.format?(/\A[+-]?\d+\Z/) }`|
| `validates :attr, numericality: { greater_than: int }`            | `required(:attr){ |attr| attr.value_is_a_number? & attr.gt?(int) }`               |
| `validates :attr, numericality: { greater_than_or_equal_to: int }`| `required(:attr){ |attr| attr.value_is_a_number? & attr.gteq?(int) }`             |
| `validates :attr, numericality: { less_than: int }`               | `required(:attr){ |attr| attr.value_is_a_number? & attr.lt?(int) }`               |
| `validates :attr, numericality: { less_than_or_equal_to: int }`   | `required(:attr){ |attr| attr.value_is_a_number? & attr.lteq?(int) }`             |
| `validates :attr, numericality: { equal_to: int }`                | `required(:attr){ |attr| attr.value_is_a_number? & attr.eql?(int) }`              |
| `validates :attr, numericality: { odd: int }`                     | custom predicate                                   |
| `validates :attr, numericality: { even: int }`                    | custom predicate                                   |

Whilst dry validation does not have a build in predicate for odd and even, it is not difficult to add. You could use:

```ruby
def odd?(value)
  value.to_i.odd
end

def even?(value)
  value.to_i.even
end
```

### 2.9 presence
| Active Record Validation          | Dry Validation                       |
|-----------------------------------|--------------------------------------|
| `validates :attr, presence: true` | `required(:attr) { |attr| attr.filled? }` |

#### Associations
If you want to be sure that an association is present, you'll need to create a custom predicate to test whether the associated object itself is present.

If you want to replicate Active Record's presence validation of an object associated via a has_one or has_many relationship (checking `.blank?` and `.marked_for_destruction?`), you will need a custom predicate.

#### Booleans
If you want to validate the presence of a boolean field (e.g. true or false) you should use the built in predicate `.bool?`.
E.g. `required(:attr) { |attr| attr.bool? }`

### 2.10 absence
| Active Record Validation          | Dry Validation                                                             |
|-----------------------------------|----------------------------------------------------------------------------|
| `validates :attr, absence: true`  | `required(:attr) { |attr| attr.blank? }` or `key(:attr) { |attr| attr.empty? }` |

#### none? or empty?
`empty?` allows an empty string(```""```), array(```[]```), hash(```{}```) etc.

`none?` allows `nil`

E.g.
`{}.empty? == true`, `[].empty? == true`, `"".empty? == true`, `nil.empty? == false`

`{}.none? == false`, `[].none? == false`, `"".none? == false`, `nil.none? == true`

Use whichever is most applicable remembering that an empty string can be turned into nil when using to_nil coercion.

#### Associations
If you want to be sure that an association is absent, you'll need create a custom predicate to test whether the associated object itself is absent.

#### Booleans
To validate the absence of a boolean field (e.g. not true or false) you should use:

`required(:attr) { |attr| attr.exclusion?([true, false]) }`

### 2.11 uniqueness
Custom Predicate

### 2.12 validates_with

### 2.13 validates_each

### 3. Common Validation Options
These are the common options allowed by ActiveRecord validations and their equivalents in Dry Validation

#### 3.1 `:allow_nil`
add `.none?` into your rule E.g.

**Active Record:** `validates :attr, length: { minimum: int, allow_nil: true }`

**Dry Validation:** `required(:attr) { |attr| attr.none? | attr.min_size?(int) }`

#### 3.2  `:allow_blank`
add `.empty?` into your rule

**Active Record:** `validates :attr, length: { minimum: int, allow_blank: true }`

**Dry Validation:** `required(:attr) { |attr| attr.empty? | attr.min_size?(int) }`

#### 3.3 `:message`
Custom messages are implemented through a separate yaml file (see [wiki page](https://github.com/dry-rb/dry-validation/wiki/Error-Messages))

#### 3.4 `:on`
To validate based on the state of the object (e.g. create or update) you would need to create a custom rule and access the persisted status of the object.
**Unsure whether this is possible**

### 4. Conditional Validation
In Active Record you can use `:if` or `:unless` to only perform a validation based on the result of a proc or method.
For example:
```ruby
validates :card_number, presence: true, if: :paid_with_card?

def paid_with_card?
  payment_type == "card"
end
```

To achieve this in Dry Validation you will need to create a custom rule.

.1. Initially we declare a rule for each of the attributes we need to reference
```ruby
required(:payment_type) { |payment_type| payment_type.inclusion?(["card", "cash", "cheque"]) }
required(:card_number) { |card_number| card_number.none? | card_number.filled? }
```
.2. Declare a custom predicate to check if `payment_type == 'card'`
```ruby
def paid_with_card?(value)
  value == "card"
end
```

.3. Declare a high level rule to require the card number if `payment_type == 'card'`
```ruby
rule(:require_card_number) do
  rule(:payment_type).paid_with_card? > rule(:card_number).filled?
end
```

Put it all together and you get:
```ruby
required(:payment_type) { |payment_type| payment_type.inclusion?(["card", "cash", "cheque"]) }
required(:card_number) { |card_number| card_number.none? | card_number.filled? }

rule(:require_card_number) do
  rule(:payment_type).paid_with_card? > rule(:card_number).
end

def paid_with_card?(value)
  value == "card"
end
```
