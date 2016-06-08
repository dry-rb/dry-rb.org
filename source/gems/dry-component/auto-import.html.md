---
title: Auto-Import
layout: gem-single
---

After defining a container, we can use its import module that will inject object dependencies automatically.

Let's say we have an `Application` container and an object that will need a logger:

``` ruby
# In a class definition you simply specify what it needs
class PostPublisher
  include Application::Inject['utils.logger']

  def call(post)
    # some stuff
    logger.debug("post published: #{post}")
  end
end
```

### Directory Structure

You need to provide a specific directory/file structure but names of directories are configurable. The default is as follows:

```
#{root}
  |- core
    |- boot
      # arbitrary files that are automatically loaded on finalization
```
