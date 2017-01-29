---
title: Exposures
layout: gem-single
---

Use _exposures_ to declare and prepare the data for your view controller's template.

An exposure can take a block:

```ruby
class MyView < Dry::View::Controller
  expose :users do |input|
    users_repo.listing(page: input[:page])
  end
end
```

Or refer to an instance method:

```ruby
class MyView < Dry::View::Controller
  expose :users

  private

  def users(input)
    users_repo.listing(page: input[:page])
  end
end
```

Or allow a matching key from the input data to pass through to the view:

```ruby
class MyView < Dry::View::Controller
  # With no matching instance method, passes the `users` key from the `#call`
  # input straight to the view
  expose :users
end
```

## Depending on other exposures

Sometimes, you want to prepare input data for other exposures to use. You can _depend_ on another exposure by naming it in your exposure block or method's argument list.

```ruby
class MyView < Dry::View::Controller
  expose :users do |input|
    users_repo.listing(page: input[:page])
  end

  expose :users_count do |users|
    users.to_a.length
  end
end
```

In this example, the `users_count` exposure has access to the value of the `users` exposure since it named the exposure in its arguments list.

Parsing of exposure arguments works as follows:

- For the first argument, if there is no matching exposure, then it receives the full input hash.
- Subsequent arguments must correspond to other exposures.

## Private exposures

You can also create _private exposures_ that are not passed to the view. This is helpful if you have an exposure that others will depend on, but is not otherwise needed in the view. Use `private_expose` to do this:

```ruby
class MyView < Dry::View::Controller
  private_expose :users_listing do
    users_repo.listing
  end

  expose :users do |users_listing|
    # does something with users_listing
  end

  expose :users_count do |users_listing|
    # also needs to work with users_listing
  end
end
```

In this example, only the values for `users` and `users_count` will be passed to the view.

##
