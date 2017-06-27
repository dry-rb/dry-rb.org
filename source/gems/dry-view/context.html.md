---
title: Context
layout: gem-single
name: dry-view
---

You can provide a context object to a view controller that will be made available as part of the scope for all templates that it renders (layouts, templates, and partials). The context object is intended as a "baseline rendering context" for the templates.

It most usefully holds data that you wouldn't want to pass around explicitly, e.g.:

- Request-specific data like CSRF tags
- A "current user" or similar session-based data needed across multiple places
- Application assets helpers
- "Content for" helpers

A context object can be set as part of a view controller's configuration:

```ruby
class MyView < Dry::View::Controller
  configure do |config|
    config.context = MyContext.new
  end
end
```

Or it can be provided when calling the view controller. A context object provided here will override whatever is available in the configuration:

```ruby
view.(context: my_context)
```
