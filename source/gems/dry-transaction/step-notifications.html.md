---
title: Step notifications
layout: gem-single
name: dry-transaction
---

As well as matching on the final transaction result, you can subscribe to individual steps and trigger specific behaviours based on their success or failure.

You can subscribe to events from specific steps using `#subscribe(step_name: listener)`, or subscribe to all steps via `#subscribe(listener)`.

The transaction will broadcast the following events for each step:

- `step` (with `step_name:` and `args:`, representing the name of the step and an array of arguments passed to the step)
- `step_succeeded` (with `step_name:`, `args:`, and `value:`, which is the return value of the step)
- `step_failed` (with `step_name:`, `args:`, and `value:`)

For example:

```ruby
NOTIFICATIONS = []

class CreateUser
  include Dry::Transaction(container: Container)

  step :process
  step :validate
  step :persist
end

module UserPersistListener
  extend self

  def on_step(event)
    NOTIFICATIONS << "Started persistence of #{user[:email]}"
  end

  def on_step_succeeded(event)
    user = event[:value]
    NOTIFICATIONS << "#{user[:email]} persisted"
  end

  def on_step_failure(event)
    user = event[:value]
    NOTIFICATIONS << "#{user[:email]} failed to persist"
  end
end

create_user = CreateUser.new

input = {"name" => "Jane", "email" => "jane@doe.com"}

create_user.subscribe(persist: UserPersistListener)
create_user.with_step_args(validate: "doe.com").call(input)

NOTIFICATIONS
# => ["Started persistence of jane@doe.com", "jane@doe.com persisted"]
```

This pub/sub mechanism is provided by [dry-events](/gems/dry-events).
