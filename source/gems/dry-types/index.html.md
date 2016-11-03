---
title: Introduction
layout: gem-single
type: gem
name: dry-types
sections:
  - including-types
  - built-in-types
  - strict
  - optional-values
  - default-values
  - sum
  - constraints
  - hash-schemas
  - array-with-member
  - enum
---

`dry-types` is a simple and extendable type system for Ruby; useful for value coercions, applying constraints, defining complex structs or value objects and more. It was created as a successor to [Virtus](https://github.com/solnic/virtus).

### Example usage

```ruby
require 'dry-types'
require 'dry-struct'

module Types
  include Dry::Types.module
end

class User < Dry::Struct
  attribute :name, Types::String
  attribute :age,  Types::Int
end

User.new(name: 'Bob', age: 35)
# => #<User name="Bob" age=35>
```

See [Built-in Types](/gems/dry-types/built-in-types/) for a full list of available types.

By themselves, the basic type definitions like `Types::String` and `Types::Int` don't do anything except provide documentation about type an attribute is expected to have. However, there are many more advanced possibilities:

- 'Strict' types will raise an error if passed an attribute of the wrong type:

        class User < Dry::Struct
          attribute :name, Types::Strict::String
          attribute :age,  Types::Strict::Int
        end

        User.new(name: 'Bob', age: '18')
        # => Dry::Struct::Error: [User.new] "18" (String) has invalid type for :age

- 'Coercible' types will attempt to convert an attribute to the correct class
  using Ruby's inbuilt coercion methods:

        class User < Dry::Struct
          attribute :name, Types::Coercible::String
          attribute :age,  Types::Coercible::Int
        end

        User.new(name: 'Bob', age: '18')
        # => #<User name="Bob" age=18>
        User.new(name: 'Bob', age: 'not coercible')
        # => ArgumentError: invalid value for Integer(): "not coercible"

- Use `.optional` to denote that an attribute can be `nil` (see [Optional Values](/gems/dry-types/optional-values)):

        class User < Dry::Struct
          attribute :name, Types::Strict::String
          attribute :age,  Types::Strict::Int.optional
        end

        User.new(name: 'Bob', age: nil)
        # => #<User name="Bob" age=nil>
        # name is not optional:
        User.new(name: nil, age: 18)
        # => Dry::Struct::Error: [User.new] nil (NilClass) has invalid type for :name
        # keys must still be present:
        User.new(name: 'Bob')
        Dry::Struct::Error: [User.new] :age is missing in Hash input

- You can add your own custom constraints (see [Constraints](/gems/dry-types/constraints.html):

        class User < Dry::Struct
          attribute :name, Types::Strict::String
          attribute :age,  Types::Strict::Int.constrained(gteq: 18)
        end

        User.new(name: 'Bob', age: 17)
        # => Dry::Struct::Error: [User.new] 17 (Fixnum) has invalid type for :age

- Add custom metadata to a type:

        class User < Dry::Struct
          attribute :name, Types::String
          attribute :age,  Types::Int.meta(info: 'extra info about age')
        end

... and more.

Note that you don't have to use `Dry::Struct`. You can interact with your
type definitions however you like using `[]`:

```ruby
Types::Strict::String["foo"]
# => "foo"
Types::Strict::String["10000"]
# => "10000"
Types::Coercible::String[10000]
# => "10000"
Types::Strict::String[10000]
# Dry::Types::ConstraintError: 1000 violates constraints
```

### dry-types vs virtus

[Virtus](https://github.com/solnic/virtus) has been a successful library, unfortunately it is "only" a by-product of an ActiveRecord ORM which carries many issues typical to ActiveRecord-like features that we all know from Rails, especially when it comes to very complicated coercion logic, mixing unrelated concerns, polluting application layer with concerns that should be handled at the boundaries etc.

`dry-types` has been created to become a better tool that solves *similar* (but not identical!) problems related to type-safety and coercions. It is a superior solution because:

* Types are [categorized](/gems/dry-types/built-in-types), which is especially important for coercions
* Types are objects and they are easily reusable
* Has [constrained types](/gems/dry-types/constraints)
* Has [optional values](/gems/dry-types/optional-values)
* Has [default values](/gems/dry-types/default-values)
* Has [sum types](/gems/dry-types/sum)
* Has [enums](/gems/dry-types/enum)
* Has [hash type with type schemas](/gems/dry-types/hash-schemas)
* Has [array type with members](/gems/dry-types/array-with-member)
* Provides struct-like objects via [dry-struct](/gems/dry-struct)
* Suitable for many use-cases while remaining simple, in example:
  * Params coercions
  * Domain "models"
  * Defining various domain-specific, shared information using enums or values
  * Annotating objects
  * and more...
* There's no const-missing magic and complicated const lookups like in Virtus
* AND is roughly 10-12x faster than Virtus
