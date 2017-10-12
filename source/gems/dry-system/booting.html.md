---
title: Booting a Dependency
layout: gem-single
name: dry-system
---

In some cases a dependency can be huge, so huge it needs to load some additional files (often 3rd party code) and it may rely on custom configuration.

Because of this reason `dry-system` has the concept of booting a dependency.

The convention is pretty simple. You put files under `system/boot` directory and use your container to register dependencies with the ability to postpone finalization. This gives us a way to define what's needed but load it and boot it on demand.

Here's a simple example:

``` ruby
# under /my/app/boot/heavy_dep.rb

Application.finalize(:persistence) do |container|
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
class Application < Dry::System::Container
  configure do |config|
    config.root = '/my/app'
  end
end

Application.start(:persistence)

# and now `database` becomes available
Application['database']
```

### Lifecycles

In some cases, a bootable dependency may have multiple stages of initialization, to support it `dry-system` provides 3 levels of booting:

* `init` - basic setup code, here you can require 3rd party code and perform basic configuration
* `start` - code that needs to run for a component to be usable at application's runtime
* `stop` - code that needs to run to stop a component, ie close a database connection, clear some artifacts etc.

Here's a simple example:

``` ruby
# system/boot/db.rb

Application.finalize(:db) do |container|
  init do
    require 'some/3rd/party/db'

    container.register(:db, DB.configure(ENV['DB_URL']))
  end

  start do
    db.establish_connection
  end

  stop do
    db.close_connection
  end
end
```

### Using other bootable dependencies

It is often needed to use another dependency when booting a component, you can use a convenient `use` API for that, it will auto-boot required dependency
and make it available in the booting context:

``` ruby
# system/boot/logger.rb
Application.finalize(:logger) do |container|
  require 'logger'
  container.register(:logger, Logger.new($stdout))
end

# system/boot/db.rb
Application.finalize(:db) do |container|
  use :logger
  container.register(DB.new(ENV['DB_URL'], logger: logger))
end
```
