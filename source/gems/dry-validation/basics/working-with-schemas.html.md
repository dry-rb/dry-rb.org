---
title: Working With Schemas
layout: gem-single
---

A schema is an object which contains a list of rules that will be applied to its input when you call a schema. It returns a `result object` which provides an API to retrieve `error messages` and access to the validation `output`.

Schema definition best practices:

* Be specific about the exact shape of the data, define all the keys that you expect to be present
* Specify optional keys too, even if you don't need additional rules to be applied to their values
* Specify type expectations for all the values!
* Use custom predicates to keep things concise when built-in predicates create too much noise
* Assign schema objects to constants for convenient access

### Calling a Schema

Calling a schema will apply all its rules to the input. High-level rules defined with `rule` API are applied in a second step and they are guarded, which means if the values they depend on are not valid, nothing will crash and a high-level rule will not be applied.

Example:

``` ruby
schema = Dry::Validation.Schema do
  key(:email).required
  key(:age).required
end

result = schema.call(email: 'jane@doe.org', age: 21)

# access validation output data
result.output
# => {:email=>'jane@doe.org', :age=>21}

# check if all rules passed
result.success?
# => true

# check if any of the rules failed
result.failure?
# => false
```

### Working With Messages

The result object returned by `Schema#call` provides an API to convert error objects to human-friendly messages.

``` ruby
result = schema.call(email: nil, age: 21)

# get default messages
result.messages
# => {:email=>['must be filled']}

# get full messages
result.messages(full: true)
# => {:email=>['email must be filled']}

# get messages in another language
result.messages(locale: :pl)
# => {:email=>['musi być wypełniony']}
```
