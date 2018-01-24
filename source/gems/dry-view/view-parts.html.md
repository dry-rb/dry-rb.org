---
title: View parts
layout: gem-single
name: dry-view
---

All values exposed by a view controller are decorated and passed to your templates as _view parts_, which add view-specific behaviour to your application's domain objects.

## Accessing your values

You can access your value's methods through the part via standard `#method_missing` behavior:

```erb
<%# All the methods on "user" are still available: %>
<p><%= user.name %></p>
```

Direct string conversion is also available via your value's `#to_s` behavior:

```erb
<p><%= user %></p>
```

## Rendering partials

You can also render partials with the part included in the partial's locals:

```erb
<%= user.render :info_box %>
```

This renders an `_info_box` partial template (via the standard [partial lookup rules](/gems/dry-view/templates/)) with the user part still available as `user`.

If you need to make the part available by another name, use the `as` option:

```erb
<%= user.render :info_box, as: :account %>
```

You can also provide additional locals for the partial:

```erb
<%= user.render :info_box, as: :account, title_label: "Your account" %>
```

## Using custom parts

View parts become especially useful when you provide your own custom part classes. This allows you to cleanly encapsulate custom view-specific behavior for your values.

Your part class should inherit from `Dry::View::Part`. It can access all the value's methods, and can also access the value directly via a `#value` accessor (or `#_value` if your value object responds to `#value`).

```ruby
class UserPart < Dry::View::Part
  def display_name
    "#{full_name} <#{email}>"
  end
end
```

Associate your part class with your value via an `:as` option on your [exposure](/gems/dry-view/exposures):

```ruby
class MyView < Dry::View::Controller
  expose :user, as: UserPart
end
```

For arrays, the `:as` part class will decorate the members of the array. To decorate the array itself, as well as its members, pass both part classes in hash form:

```ruby
class MyView < Dry::View::Controller
  expose :users, as: {MyArrayPart => MyUserPart}
end
```

## Accessing view context

In your part classes, you can access the view's [context object](/gems/dry-view/context) as `#context` (or `#_context` if your value object responds to `#context`).

This makes it possible to design view parts that encapsulate value-specific along with view-specific behavior. This is the kind of thing that would otherwise need to be handled by a messy collection of helpers.

For example, if your "user" contains a `#bio_markup` attribute with raw markup for "bio" content, your part can offer a `#bio_html` method that returns the fully rendered content, using the context object to pass whatever view-specific information the renderer may require (like a CSRF token, for example).

Since view parts object live for the entirety of the template rendering, you can memoize expensive operations like this rendering to ensure it only runs once.

```ruby
class UserPart < Dry::View::Part
  def bio_html
    @bio ||= rich_text(bio_markup)
  end

  private

  def rich_text(str)
    rich_text_renderer.render(str, csrf_token: context.csrf_token)
  end

  def rich_text_renderer
    @rich_text_renderer ||= MyRenderer.new
  end
end
```

You could also encapsulate the rendering of partials, and thanks to the [partial lookup rules](/gems/dry-view/templates/), you can provide different partials to be used based on the location of the top-level template.

```ruby
class UserPart < Dry::View::Part
  def profile
    render(:profile)
  end
end
```

Providing custom view parts like this ensures more of your view logic is properly encapsulated and easier to test.

## Decorating part attributes

Your values may have their own attributes that you also want decorated as view parts. Declare these using `decorate` in your own view part classes:

```ruby
class UserPart < Dry::View::Part
  decorate :address, as: AddressPart
end
```

You can pass the same options to `decorate` as you do to `expose` in your view controllers.


## Providing a custom decorator

Provide a custom _decorator_ to a view controller to control its behaviour of decorating the exposed values.

```ruby
class MyView < Dry::View::Controller
  configure do |config|
    config.decorator = MyDecorator.new
  end
end
```

A decorator must respond to `#call(name, value, renderer:, context:, **options)` and return `Dry::View::Part` objects (or equivalent). The arguments to `#call` are as follows,

- **name**: the name of the exposure
- **value**: the object returned from the exposure. This should be provided when initializing the part object.
- **renderer**: the current low-level renderer. This should be provided when initializing the part object.
- **context**: the current [context object](/gems/dry-view/context/). This should be  provided when initializing the part object.
- **options**: a hash of any other options provided to the exposure. These can be used, for example, to determine what part class to use, or to pass extra data when initializing custom parts.

Your custom decorator must also take care of handling plain values as well as arrays of values (see the implementation of the default `Dry::View::Decorator` for detail).

If you'd like to keep this standard behaviour, you can instead inherit from `Dry::View::Decorator` and provide a simpler `#part_class(name, value, **options)` method, which only has to return the part class based on the passed arguments.

```ruby
class MyDecorator < Dry::View::Decorator
  def part_class(name, value, **options)
    # some logic to automatically determine a part class based on name, value, or options
  end
end
```

