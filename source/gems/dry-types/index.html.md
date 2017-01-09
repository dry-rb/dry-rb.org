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

`dry-types` is a simple and extendable type system for Ruby with support for coercions and constraints.

### Features

* Support for [constrained types](/gems/dry-types/constraints)
* Support for [optional values](/gems/dry-types/optional-values)
* Support for [default values](/gems/dry-types/default-values)
* Support for [sum types](/gems/dry-types/sum)
* Support for [enums](/gems/dry-types/enum)
* Support for [hash type with type schemas](/gems/dry-types/hash-schemas)
* Support for [array type with members](/gems/dry-types/array-with-member)
* Support for arbitrary meta information
* Support for typed struct objects via [dry-struct](/gems/dry-struct)
* Types are [categorized](/gems/dry-types/built-in-types), which is especially important for optimized and dedicated coercion logic
* Types are composable and reusable objects
* No const-missing magic and complicated const lookups
* Roughly 6-10 x faster than Virtus

### Use cases

`dry-types` is suitable for many use-cases, for example:

  * Value coercions
  * Processing arrays
  * Processing hashes with explicit schemas
  * Defining various domain-specific information shared between multiple parts of your applications
  * Annotating objects

### Other gems using dry-types

`dry-types` is often used as a low-level abstraction. The following gems use it already:

* [dry-struct](/gems/dry-struct)
* [dry-initializer](/gems/dry-initializer)
* [Hanami](https://hanamirb.org)
* [rom-rb](http://rom-rb.org)
* [Trailblazer](http://trailblazer.to)
