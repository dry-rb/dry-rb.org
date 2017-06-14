---
title: Injecting operations via initializer
layout: gem-single
---

At initialization we can inject different operations, making possible to overwrite operations defined as instance methods or in the container.

This is possible because when generating a new instance of a transaction it will try to fetch any key with the same name of the operations defined in the transaction class - if it find one in the arguments it will use it, if not it will default for the ones in the container or the instance methods.

Every operation injected via initializer must respond to `#call(input)`.

```ruby
class CreateUser
  include Dry::Transaction(container: Container)

  step :process, with: "operations.process"
  step :validate, with: "operations.validate"
  step :persist, with: "operations.persist"
end

DB = []

create_user = CreateUser.new(validate: -> (input){ Right(input.merge(foo: "bar")) })
create_user.call("name" => "Jane", "email" => "jane@doe.com")
# => Right({:name=>"Jane", :email=>"jane@doe.com", :foo => "bar"})

DB
# => [{:name=>"Jane", :email=>"jane@doe.com", :foo => "bar"}]
```
