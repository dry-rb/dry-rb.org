---
title: Current Time
layout: gem-single
name: dry-effects
---

Obtaining the current time with `Time.now` is a classic example of a side effect. Code relying on accessing system time is harder to test. One possible solution is passing time around explicitly, but using effects can save you some typing depending on the case.

Providing and obtaining the current time is straightforward:

```ruby
require 'dry/effects'

class CurrentTimeMiddleware
  include Dry::Effects::Handler.CurrentTime

  def initialize(app)
    @app = app
  end

  def call(env)
    # It will use Time.now internally once and set it fixed
    with_current_time do
      @app.(env)
    end
  end
end

###

class CreateSubscription
  include Dry::Efefcts.Resolve(:subscription_repo)
  include Dry::Effects.CurrentTime

  def call(values)
    subscription_repo.create(
      values.merge(start_at: current_time)
    )
  end
end
```

### Providing time in tests

A typical usage would be:

```ruby
require 'dry/effects'

provide_time = Object.new.extend(Dry::Effects::Handler.CurrentTime)

RSpec.configure do |config|
  config.around { |ex| provide_time.(&ex) }
  config.include Dry::Effects.CurrentTime
end
```

Then anywhere in tests, you can use it:

```ruby
it 'uses current time as a start' do
  subscription = create_subscription(...)
  expect(subscription.start_at).to eql(current_time)
end
```

To change the time, call `with_current_time` again:

```ruby
it 'closes a subscription with current time' do
  future = current_time + 86_400
  closed_subscription = with_current_time(future) { close_subscription(subscription) }
  expect(closed_subscription.closed_at).to eql(future)
end
```

### Time rounding

`current_time` accepts an argument for rounding time values. It can be passed statically to the module builder or dynamically to the effect constructor:

```ruby
class CreateSubscription
  include Dry::Effects.CurrentTime(round: 3)

  def call(...)
    # value will be rounded to milliseconds
    current_time
    # value will be rounded to microseconds
    current_time(round: 6)
  end
end
```

### Time is fixed

By default, calling `with_current_time` even without arguments will freeze the current time. This means `current_time` will return the same value during request processing etc.

You can "unfix" time with passing `fixed: false` to the handler builder:

```ruby
include Dry::Effects::Handler.CurrentTime(fixed: false)
```

However, this is not recommended because it will make the behavior of `current_time` different in tests (where you pass a fixed value) and in a production environment.
