---
title: Booting a Dependency
layout: gem-single
---

In some cases a dependency can be huge, so huge it needs to load some additional files (often 3rd party code) and it may rely on custom configuration.

Because of this reason `dry-component` has the concept of booting a dependency.

The convention is pretty simple. You put files under `boot` directory and use your container to register dependencies with the ability to postpone finalization. This gives us a way to define what's needed but load it and boot it on demand.

Here's a simple example:

``` ruby
# under /my/app/boot/heavy_dep.rb

Application.finalize(:persistence) do
  # some 3rd-party dependency
  require '3rd-party/database'

  container.register('database') do
    # some code which initializes this thing
  end
end
```

After defining the finalization block our container will not call it until its own finalization. This means we can require file that defines our container and ask it to boot *just that one :persistence dependency*:

``` ruby
# under /my/app/boot/container.rb
class Application < Dry::Component::Container
  configure do |config|
    config.root = '/my/app'
  end
end

Application.boot!(:persistence)

# and now `database` becomes available
Application['database']
```

