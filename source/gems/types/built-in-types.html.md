---
title: Built-in Types
layout: gem-single
name: types
order: 2
---

Built-in types are grouped under 5 categories:

- `definition` - base type definitions with primitive class and options
- `strict` - constrained types with a primitive type check applied to input
- `coercible` - types with constructors using kernel coercions
- `form` - types with constructors performing non-strict coercions
- `maybe` - types accepting either nil or a specific primitive type

### Categories

Assuming you included types in `Types` module:

Base definitions:

- `Types::Nil`
- `Types::Symbol`
- `Types::Class`
- `Types::True`
- `Types::False`
- `Types::Bool`
- `Types::Date`
- `Types::DateTime`
- `Types::Time`
- `Types::Array`
- `Types::Hash`

Coercible types using kernel coercion methods:

- `Types::Coercible::String`
- `Types::Coercible::Int`
- `Types::Coercible::Float`
- `Types::Coercible::Decimal`
- `Types::Coercible::Array`
- `Types::Coercible::Hash`

Optional strict types:

- `Types::Maybe::Strict::String`
- `Types::Maybe::Strict::Int`
- `Types::Maybe::Strict::Float`
- `Types::Maybe::Strict::Decimal`
- `Types::Maybe::Strict::Array`
- `Types::Maybe::Strict::Hash`

Optional coercible types:

- `Types::Maybe::Coercible::String`
- `Types::Maybe::Coercible::Int`
- `Types::Maybe::Coercible::Float`
- `Types::Maybe::Coercible::Decimal`
- `Types::Maybe::Coercible::Array`
- `Types::Maybe::Coercible::Hash`

Coercible types suitable for form param processing:

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
