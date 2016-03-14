---
title: Introduction
layout: gem-single
type: gem
order: 2
name: types
---

`dry-types` is a simple and extendible type system for Ruby with support for kernel coercions,
form coercions, sum types, constrained types and default-value types.

Used by:

* [dry-validation](https://github.com/dryrb/dry-validation) for params coercions
* [rom-repository](https://github.com/rom-rb/rom-repository) for auto-mapped structs
* [rom](https://github.com/rom-rb/rom)'s adapters for relation schema definitions
* your project...?

Articles:

* ["Invalid Object Is An Anti-Pattern"](http://solnic.eu/2015/12/28/invalid-object-is-an-anti-pattern.html)

## dry-types vs virtus

[Virtus](https://github.com/solnic/virtus) has been a successful library, unfortunately
it is "only" a by-product of an ActiveRecord ORM which carries many issues typical
to ActiveRecord-like features that we all know from Rails, especially when it
comes to very complicated coercion logic, mixing unrelated concerns, polluting
application layer with concerns that should be handled at the bounderies etc.

`dry-types` has been created to become a better tool that solves *similar* (but
not identical!) problems related to type-safety and coercions. It is a superior
solution because:

* Types are [categorized](#built-in-type-categories), which is especially important for coercions
* Types are objects and they are easily reusable
* Has [structs](#structs) and [values](#values) with *a simple DSL*
* Has [constrained types](#constrained-types)
* Has [optional types](#optional-types)
* Has [defaults](#defaults)
* Has [sum-types](#sum-types)
* Has [enums](#enums)
* Has [hash type with type schemas](#hashes)
* Has [array type with member type](#arrays)
* Suitable for many use-cases while remaining simple, in example:
  * Params coercions
  * Domain "models"
  * Defining various domain-specific, shared information using enums or values
  * Annotating objects
  * and more...
* There's no const-missing magic and complicated const lookups like in Virtus
* AND is roughly 10-12x faster than Virtus

## Rails

If you're using Rails then you want to install [dry-types-rails](https://github.com/jeromegn/dry-types-rails) which makes it work in development mode.
