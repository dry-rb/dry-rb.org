---
title: Schemas
layout: gem-single
name: dry-validation
---

Schemas are a crucial part of `dry-validation`, they pre-process the data before it's validated by [the rules](/gems/dry-validation/rules) and can provide detailed error messages. By default, the exposed DSL for defining schemas uses [`dry-schema`](/gems/dry-schema) under the hood.

### Defining a schema without coercion

To define a schema that does not perform coercion, use `schema` method:

``` ruby
class NewUserContract < Dry::Validation::Contract
  schema do
    required(:email).value(:string)
    required(:age).value(:integer)
  end
end
```

Now when a contract is applied, it will check the structure and types of the input:

``` ruby
contract = NewUserContract.new

result = contract.call(unexpected: :reality, age: 21)
# => #<Dry::Validation::Result{:age=>21} errors={:email=>["is missing"]}>

result.to_h
# => {:age=>21}

result.errors.to_h
# => {:email=>["is missing"]}
```

### Defining a schema with Params coercion

If you want to define a contract suitable for validating HTTP parameters, simply use `params` method:

``` ruby
class NewUserContract < Dry::Validation::Contract
  params do
    required(:email).value(:string)
    required(:age).value(:integer)
  end
end
```

The major difference between plain `schema` and `params`, is that the latter will perform params-specific coercions prior applying rules:

``` ruby
result = contract.call('email' => 'jane@doe.org', 'age' => '21')
# => #<Dry::Validation::Result{:email=>"jane@doe.org", :age=>21} errors={}>

result.to_h
# => {:email=>"jane@doe.org", :age=>21}
```

### Defining a schema with JSON coercion

In a similar way like `params`, you can use `json` to define a contract that's suitable for validating JSON data:

``` ruby
class NewUserContract < Dry::Validation::Contract
  json do
    required(:email).value(:string)
    required(:age).value(:integer)
  end
end
```

Coercion logic is different than in case of `params`, for example:

``` ruby
result = contract.call('email' => 'jane@doe.org', 'age' => '21')
# => #<Dry::Validation::Result{:email=>"jane@doe.org", :age=>"21"} errors={:age=>["must be an integer"]}>

result = contract.call('email' => 'jane@doe.org', 'age' => 21)
# => #<Dry::Validation::Result{:email=>"jane@doe.org", :age=>"21"} errors={}>

result.to_h
# => {:email=>"jane@doe.org", :age=>21}
```

### Using custom types

When you use `params` or `json`, coercion logic is handled by type objects that are resolved from the type specifications. For example when you use `params` and define the type to be an `:integer`, then the resolved type will be `Dry::Schema::Types::Params::Integer`. This is just a convenience in order to make schema definition more concise.

If you want **custom types**, you can **pass them explicitly** when defining your schema:

```ruby
module Types
  include Dry::Types()

  StrippedString = Types::String.constructor(&:strip)
end

class NewUserContract < Dry::Validation::Contract
  params do
    required(:email).value(Types::StrippedString)
    required(:age).value(:integer)
  end
end
```

Now your type will be applied:

```ruby
contract.call(email: '   jane@doe   ', age: 21)
# => #<Dry::Validation::Result{:email=>"jane@doe", :age=>21} errors={}>
```

### Learn more

- [dry-schema](/gems/dry-schema) learn how to fully leverage schemas!
- [dry-types](/gems/dry-types) learn more about the coercion backend used in the schemas
- [rules](/gems/dry-validation/rules) learn how to define validation rules in addition to schemas