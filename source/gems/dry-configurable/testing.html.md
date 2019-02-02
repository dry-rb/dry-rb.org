---
title: Testing
layout: gem-single
name: dry-configurable
---

### How to reset the config to its original state on testing environment

update `spec_helper.rb` :

```ruby
require "dry/configurable/test_interface"

# this is your module/class that extend Dry::Configurable
module AwesomeModule
  # add this code
  extend Dry::Configurable::TestInterface
end
```

and on spec file (`xxx_spec.rb`) :

```ruby
before(:all) { AwesomeModule.reset_config }

# or 
before(:each) { AwesomeModule.reset_config }

```
