---
title: Exposures
layout: gem-single
name: dry-view
---

Use _exposures_ to declare and prepare the data for your view controller's template.

An exposure can take a block:

```ruby
class MyView < Dry::View::Controller
  expose :users do
    user_repo.listing
  end
end
```

Or refer to an instance method:

```ruby
class MyView < Dry::View::Controller
  expose :users

  private

  def users
    user_repo.listing
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

## Using input data

If your exposure needs to work with input data (i.e. the arguments passed to the view controller’s `#call`), specify these as keyword arguments for your exposure block. Make this a required keyword argument if you require the data passed to the view controller’s `#call`:

```ruby
class MyView < Dry::View::Controller
  expose :users do |page:|
    user_repo.listing(page: page)
  end
end
```

The same applies to instance methods acting as exposures:

```ruby
class MyView < Dry::View::Controller
  expose :users

  private

  def users(page:)
    user_repo.listing(page: page)
  end
end
```

## Specifying defaults

If you want input data to be optional, provide a default value for the keyword argument (either `nil` or something more meaningful):

```ruby
class MyView < Dry::View::Controller
  expose :users do |page: 1|
    user_repo.listing(page: page)
  end
end
```

If your exposure passes data passes through input data directly, use the `default:` option:

```ruby
class MyView < Dry::View::Controller
  # With no matching instance method, passes the `users` key from the `#call`
  # input straight to the view
  expose :users, default: []
end
```

## Depending on other exposures

Sometimes you may want to prepare data for other exposures to use. You can _depend_ on another exposure by naming it as a positional argument for your exposure block or method.

```ruby
class MyView < Dry::View::Controller
  expose :users do |page:|
    user_repo.listing(page: page)
  end

  expose :user_count do |users|
    users.to_a.length
  end
end
```

In this example, the `user_count` exposure has access to the value of the `users` exposure since it named the exposure as a positional argument.

Exposure dependencies (positional arguments) and input data (keyword arguments) can be provided together:

```ruby
expose :user_count do |users, prefix: "Users: "|
  "#{prefix}#{users.to_a.length}"
end
```

## Private exposures

You can create _private exposures_ that are not passed to the view. This is helpful if you have an exposure that others will depend on, but is not otherwise needed in the view. Use `private_expose` for this:

```ruby
class MyView < Dry::View::Controller
  private_expose :user_listing do
    user_repo.listing
  end

  expose :users do |user_listing|
    # does something with user_listing
  end

  expose :user_count do |user_listing|
    # also needs to work with user_listing
  end
end
```

In this example, only `users` and `user_count` will be passed to the view.
