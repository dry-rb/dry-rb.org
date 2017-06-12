---
title: Built-in Types
layout: gem-single
---

Built-in types are grouped under 5 categories:

- `definition` - base type definitions with primitive class and options
- `strict` - constrained types with a primitive type check applied to input
- `coercible` - types with constructors using kernel coercions
- `form` - types with constructors performing non-strict coercions specific to HTTP params
- `json` - types with constructors performing non-strict coercions specific to JSON
- `maybe` - types accepting either nil or a specific primitive type

### Categories

Assuming you included types in a module called `Types`:

* Base definitions:
  - `Types::Any`
  - `Types::Nil`
  - `Types::Symbol`
  - `Types::Class`
  - `Types::True`
  - `Types::False`
  - `Types::Bool`
  - `Types::Int`
  - `Types::Float`
  - `Types::Decimal`
  - `Types::String`
  - `Types::Date`
  - `Types::DateTime`
  - `Types::Time`
  - `Types::Array`
  - `Types::Hash`

* `Strict` types will raise an error if passed a value of the wrong type:
  - `Types::Strict::Nil`
  - `Types::Strict::Symbol`
  - `Types::Strict::Class`
  - `Types::Strict::True`
  - `Types::Strict::False`
  - `Types::Strict::Bool`
  - `Types::Strict::Int`
  - `Types::Strict::Float`
  - `Types::Strict::Decimal`
  - `Types::Strict::String`
  - `Types::Strict::Date`
  - `Types::Strict::DateTime`
  - `Types::Strict::Time`
  - `Types::Strict::Array`
  - `Types::Strict::Hash`

* `Coercible` types will attempt to cast values to the correct class using kernel coercion methods:
  - `Types::Coercible::String`
  - `Types::Coercible::Int`
  - `Types::Coercible::Float`
  - `Types::Coercible::Decimal`
  - `Types::Coercible::Array`
  - `Types::Coercible::Hash`

* Types suitable for `Form` param processing with coercions:
  - `Types::Form::Nil`
  - `Types::Form::Date`
  - `Types::Form::DateTime`
  - `Types::Form::Time`
  - `Types::Form::True`
  - `Types::Form::False`
  - `Types::Form::Bool`
  - `Types::Form::Int`
  - `Types::Form::Float`
  - `Types::Form::Decimal`
  - `Types::Form::Array`
  - `Types::Form::Hash`

* Types suitable for `JSON` processing with coercions:
  - `Types::Json::Nil`
  - `Types::Json::Date`
  - `Types::Json::DateTime`
  - `Types::Json::Time`
  - `Types::Json::Decimal`
  - `Types::Json::Array`
  - `Types::Json::Hash`

* `Maybe` strict types:
  - `Types::Maybe::Strict::Class`
  - `Types::Maybe::Strict::String`
  - `Types::Maybe::Strict::Symbol`
  - `Types::Maybe::Strict::True`
  - `Types::Maybe::Strict::False`
  - `Types::Maybe::Strict::Int`
  - `Types::Maybe::Strict::Float`
  - `Types::Maybe::Strict::Decimal`
  - `Types::Maybe::Strict::Date`
  - `Types::Maybe::Strict::DateTime`
  - `Types::Maybe::Strict::Time`
  - `Types::Maybe::Strict::Array`
  - `Types::Maybe::Strict::Hash`

* `Maybe` coercible types:
  - `Types::Maybe::Coercible::String`
  - `Types::Maybe::Coercible::Int`
  - `Types::Maybe::Coercible::Float`
  - `Types::Maybe::Coercible::Decimal`
  - `Types::Maybe::Coercible::Array`
  - `Types::Maybe::Coercible::Hash`

> `Maybe` types are not available by default - they must be loaded using `Dry::Types.load_extensions(:maybe)`. See [Optional Values](/gems/dry-types/optional-values) for more information.
