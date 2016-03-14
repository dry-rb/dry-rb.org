---
title: Including Types
layout: gem-single
---

To include all built-in types in your own namespace simply do:

``` ruby
module Types
  include Dry::Types.module
end
```

Now you can access all built-in types inside your namespace:

``` ruby
Types::Coercible::String
# => #<Dry::Types::Constructor type=#<Dry::Types::Definition primitive=String options={}>>
```

With types accessible as constants you can easily compose more complex types:

``` ruby
module Types
  include Dry::Types.module

  Email = String.constrained(format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
  Age = Int.constrained(gt: 18)
end

class User < Dry::Types::Struct
  attribute :name, Types::String
  attribute :email, Types::Email
  attribute :age, Types::Age
end
```
