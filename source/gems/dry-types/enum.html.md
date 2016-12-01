---
title: Enum
layout: gem-single
---

In many cases you may want to define an enum. For example in a blog application a post may have a finite list of statuses. Apart from accessing the current status value it is useful to have all possible values accessible too. Furthermore an enum is an `int => value` map, so you can store integers somewhere and have them mapped to enum values conveniently.

``` ruby
# assuming we have types loaded into `Types` namespace
# we can easily define an enum for our post struct
class Post < Dry::Struct
  Statuses = Types::Strict::String.enum('draft', 'published', 'archived')

  attribute :title, Types::Strict::String
  attribute :body, Types::Strict::String
  attribute :status, Statuses
end

# enum values are frozen, let's be paranoid, doesn't hurt and have potential to
# eliminate silly bugs
Post::Statuses.values.frozen? # => true
Post::Statuses.values.all?(&:frozen?) # => true

# you can access values using indices or actual values
Post::Statuses[0] # => "draft"
Post::Statuses['draft'] # => "draft"

# it'll raise if something silly was passed in
Post::Statuses['something silly']
# => Dry::Types::ConstraintError: "something silly" violates constraints

# nil is considered as something silly too
Post::Statuses[nil]
# => Dry::Types::ConstraintError: nil violates constraints
```
