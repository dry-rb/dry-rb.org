---
title: Environment & Options
layout: gem-single
---

In most of the systems you need some kind of options for your runtime. Typically it's provided via ENV vars or a yaml file in development mode. `dry-component` has a built-in support for this.

You can simply put a file under `#{root}/config/application.yml` and it will be loaded:

``` yaml
# /my/app/config/application.yml
development:
  foo: 'bar'
```

Now let's configure our container for a specific env:

``` ruby
class Application < Dry::Component::Container
  configure('development') do |config|
    config.name = :application # this is used to determine options file name
    config.root = '/my/app'
  end
end

# now our application options are available
Application.options.foo # => "bar"
```
