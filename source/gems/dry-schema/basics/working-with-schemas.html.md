---
title: Working With Schemas
layout: gem-single
name: dry-schema
---

A schema is an object which contains a list of rules that will be applied to its input when you call a schema. It returns a `result object` which provides an API to retrieve `error messages` and access to the validation output.

Schema definition best practices:

- Be specific about the exact shape of the data, define all the keys that you expect to be present
- Specify optional keys too, even if you don't need additional rules to be applied to their values
- **Specify type specs** for all the values
- Assign schema objects to constants for convenient access
- Define a base schema for your application with common configuration

### Calling a Schema

Calling a schema will apply all its rules to the input. High-level rules defined with the `rule` API are applied in a second step and they are guarded, which means if the values they depend on are not valid, nothing will crash and a high-level rule will not be applied.

Example:

```ruby
schema = Dry::Schema.Params do
  required(:email).filled(:string)
  required(:age).filled(:integer)
end

result = schema.call(email: 'jane@doe.org', age: 21)

# access validation output data
result.to_h
# => {:email=>'jane@doe.org', :age=>21}

# check if all rules passed
result.success?
# => true

# check if any of the rules failed
result.failure?
# => false
```

### Defining Base Schema Class

```ruby
class AppSchema < Dry::Schema::Params
  config.messages.load_paths << '/my/app/config/locales/en.yml'
  config.messages.backend = :i18n

  define do
    # define common rules, if any
  end
end

# now you can build other schemas on top of the base one:
class MySchema < AppSchema
  # define your rules
end

my_schema = MySchema.new
```

### Working With Error Messages

The result object returned by `Schema#call` provides an API to convert error objects to human-friendly messages.

```ruby
result = schema.call(email: nil, age: 21)

# get default errors
result.errors.to_h
# => {:email=>['must be filled']}

# get full errors
result.errors(full: true).to_h
# => {:email=>['email must be filled']}

# get errors in another language
result.errors(locale: :pl).to_h
# => {:email=>['musi być wypełniony']}
```

### Using Validation Hints

In addition to error messages you can also access hints, which are generated from your rules. While `errors` tells you which predicate checks failed, `hints` tells you which additional predicate checks weren't evaluated at all because an earlier predicate failed:

```ruby
schema = Dry::Schema.Params do
  required(:email).filled
  required(:age).filled(gt?: 18)
end
result = schema.call(email: 'jane@doe.org', age: '')
result.hints
# {:age=>['must be greater than 18']}

result = schema.call(email: 'jane@doe.org', age: '')

result.errors
# {:age=>['must be filled']}

result.hints
# {:age=>['must be greater than 18']}
# hints takes the same options as errors:
result.hints(full: true)
# {:age=>['age must be greater than 18']}
```

You can also use `messages` to get a combination of both errors and hints:

```ruby
result = schema.call(email: 'jane@doe.org', age: '')
result.messages
# {:age=>["must be filled", "must be greater than 18"]}
```

> Learn more about customizing [error and hint messages](/gems/dry-schema/error-messages)
