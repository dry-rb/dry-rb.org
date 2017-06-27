---
title: Configuration
layout: gem-single
name: dry-view
---

You can configure your view controller classes inside a `configure` block. Basic configuration looks like this:

```ruby
class MyView < Dry::View::Controller
  configure do |config|
    config.paths = [File.join(__dir__, "templates")]
    config.layout = "app"
    config.template = "hello"
  end
end
```

### Options

- **paths** (_required_): An array of directories that will be searched for views (layouts and templates).
- **layout**: Name of the layout to render templates within. Layouts are found within a `layouts/` directory within your configured view paths. A false or nil value will use no layout. This is the default.
- **template** (_required_): Name of the template for rendering this view. Templates are found within your configured view paths.
- **default_format**: The format used when looking up template files (templates are found using a `<name>.<format>.<engine>` pattern). The default value is `:html`.
- **context**: An object made available as part of the scope for rendering all layouts and templates.

## Sharing configuration with inheritance

In an app with many views, it is helpful to use inheritance to share common settings. Create a base view controller class for your app's default settings, then inherit from it in each individual view.

```ruby
module MyApp
  class ViewController < Dry::ViewController
    # Set common configuration in the shared base view controller class
    configure do |config|
      config.paths = [File.join(__dir__, "templates")]
      config.layout = "app"
    end
  end
end

module MyApp
  module Views
    class Home < MyApp::ViewController
      # Set view-specific configuration in subclasses of the base view controller
      configure do |config|
        config.template = "home"
      end
    end
  end
end
```

## Changing configuration at render-time

Some configuration-related options can also be passed at render-time, to `Dry::View::Controller#call`.

- **format**: Specify another format for rendering the view. This overrides the `default_format` setting.
- **context**: Provide an alternative context object for the [template scope](/gems/dry-view/templates/). This is helpful for providing a context object that has request-specific data.
