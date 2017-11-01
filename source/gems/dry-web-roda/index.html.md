---
title: Introduction
layout: gem-single
type: gem
name: dry-web-roda
---

dry-web-roda provides a lightweight web stack connecting [Roda](http://roda.jeremyevans.net) with [dry-system](/gems/dry-system) and [dry-view](/gems/dry-view), and makes it easy to start a project using all the dry-rb gems along with [rom-rb](http://rom-rb.org) for database persistence.

## Project generator

dry-web-roda offers a command line utility for generating new projects. To create a new project named `MyApp`:

```sh
$ dry-web-roda new my_app
```

Then, once inside the project directory, you can generate new sub-apps (which are created inside the `apps/` directory). To create a new `MyApp::Admin` sub-app:

```sh
$ dry-web-roda generate sub_app admin --umbrella=my_app
```

The project generator is still in flux and undergoing active development, but it still represents the easiest way to start an app built to work oriented around dry-system and ready for use with all the other dry-rb gems, along with [rom-rb](http://rom-rb.org) for database persistence.

## Roda extensions

Inherit from `Dry::Web::Roda::Application` to build a web app around a container:

```ruby
module MyApp
  class Web < Dry::Web::Roda::Application
    configure do |config|
      config.container = MyApp::Container
    end
  end
end
```

### Resolving container registrations

`Dry::Web::Roda::Application` subclasses automatically enable the [roda-flow](https://github.com/AMHOL/roda-flow) plugin to make it easy to resolve objects from the container and work with them in your routes.

Use `r.resolve` to resolve one or more objects:

```ruby
module MyApp
  class Web < Dry::Web::Roda::Application
    configure do |config|
      config.container = MyApp::Container
    end

    route do |r|
      r.post "articles" do
        r.resolve "articles.create" do |create_article|
          create_article.(r[:article])
          r.redirect "/articles"
        end
      end
    end
  end
end
```

### Rendering views

Enable the `:dry_view` plugin and use `r.view` render the results of functional view objects as your HTTP responses.

```ruby
class Web < Dry::Web::Roda::Application
  configure do |config|
    config.container = MyApp::Container
  end

  route do |r|
    r.get "articles" do
      # A shortcut for this:
      #
      # r.resolve "views.articles.index" do |view|
      #   view.(page: r[:page])
      # end
      r.view "articles.index", page: r[:page]
    end
  end
end
```

### Route loader

Configure a routes path, then enable the Roda `:multi_route` plugin and run `load_routes!` to load all the route files within the path.

```ruby
module MyApp
  class Web < Dry::Web::Roda::Application
    configure do |config|
      config.container = MyApp::Container
      config.routes = "web/routes".freeze
    end

    plugin :multi_route

    route do |r|
      r.multi_route
    end

    load_routes!
  end
end
```
