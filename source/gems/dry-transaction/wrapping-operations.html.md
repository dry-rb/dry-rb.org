---
title: Wrapping operations
layout: gem-single
---

Since each transactions can relay on the instance methods defined on the class or in the operations objects inside a container, this allow us to easily wrap our operations. Making really easy to modify the input that each operation accept.

Always when you are wrapping your operations remember to call `super(new_input)`

```ruby
class CreateUser
  include Dry::Transaction(container: Container)

  step :process, with: "operations.process"
  step :validate, with: "operations.validate"
  step :persist, with: "operations.persist"

  def process(input)
    new_input = modify_input(input)
    super(new_input)
  end

  def modify_input(input)
    # transform the value for each key to upcase
    input.each_with_object({}) { |(key, value), hash| hash[key.to_sym] = value.upcase }
  end
end

DB = []

create_user = CreateUser.new
create_user.call("name" => "Jane", "email" => "jane@doe.com")
# => Right({:name=>"JANE", :email=>"JANE@DOE.COM"})

DB
# => [{:name=>"JANE", :email=>"JANE@DOE.COM"}]
```
