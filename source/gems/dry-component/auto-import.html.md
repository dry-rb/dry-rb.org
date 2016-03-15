---
title: Auto-Import
layout: gem-single
---

After defining a container, we can use its import module that will inject object dependencies automatically.

Let's say we have an object that will need a logger:

``` ruby
# let's define an import module
Import = Application.import_module

# in a class definition you simply specify what it needs
class PostPublisher
  include Import['utils.logger']

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

