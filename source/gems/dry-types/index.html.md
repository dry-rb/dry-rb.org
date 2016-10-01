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

`dry-types` is a simple and extendable type system for Ruby; useful for value coercions, applying constraints, defining complex structs or value objects and more. It was created as a virtus' successor.

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
