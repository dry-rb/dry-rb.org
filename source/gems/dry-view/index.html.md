---
title: Introduction
layout: gem-single
type: gem
name: dry-view
sections:
  - configuration
  - injecting-dependencies
  - exposures
  - context
  - templates
---

dry-view is a simple, standalone view rendering system built around functional view controllers and templates. dry-view allows you to model your views as stateless _transformations_, accepting user input and returning your rendered view.

Use dry-view if:

- You want to build and render views consistently in any kind of context (dry-view is standalone, it doesn't require an HTTP request!).
- You're using a lightweight routing DSL like Roda or Sinatra and you want to keep your routes clean and easy to understand (dry-view handles the integration with your application's objects, all you need to provide from your routes is the user input data).
- Your application uses dependency injection to make objects available to each other (dry-view fits perfectly with dry-web and dry-system).
- Want a way to test your views in isolation.

### Example

Build your view controller:

```ruby
require "dry-view"

class HelloView < Dry::View::Controller
  configure do |config|
    config.paths = [File.join(__dir__, "templates")]
    config.layout = "app"
    config.template = "hello"
  end

  expose :greeting
end
```

Write a layout (`templates/layouts/app.html.erb`):

```erb
<html>
  <body>
    <%= yield %>
  </body>
</html>
```

And a template (`templates/hello.html.erb`):

```
<h1>Hello!</h1>
<p><%= greeting %></p>
```

Then `#call` your view controller to render your view:

```ruby
view = HelloView.new
view.call(greeting: "Greetings from dry-rb")
# => "<html><body><h1>Hello!</h1><p>Greetings from dry-rb!</p></body></html>
```

`Dry::View::Controller#call` expects keyword arguments for input data. These arguments are handled by your [exposures](/gems/dry-view/exposures/), which prepare the objects that are passed to your [template](/gems/dry-view/) for rendering.
