---
title: Injecting operations
layout: gem-single
---

You can inject operation objects into transactions to adjust their behavior at runtime. This could be helpful to substitute operations with test doubles to simulate various conditions in testing.

To inject operation objects, pass them as keyword arguments to the initializer, with their keyword matching the step's name.

Every injected operation must respond to `#call(input, *args)`.

```ruby
class CreateUser
  include Dry::Transaction(container: Container)

  step :process, with: "operations.process"
  step :validate, with: "operations.validate"
  step :persist, with: "operations.persist"
end

substitute_validate_step = -> input { Left(:definitely_not_valid) }

create_user = CreateUser.new(validate: substitute_validate_step)

create_user.call("name" => "Jane", "email" => "jane@doe.com")
# => Left(:definitely_not_valid)
```
