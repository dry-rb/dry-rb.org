---
title: Namespaces
layout: gem-single
---

In complex system where you have a huge hierarchy accessing you registered components can be a little tedious dry-system provides a configuration that allow you to define the namespace for accessing them.

```ruby
class Application < Dry::System::Container
  configure do |config|
    config.root = './my/app'
    config.default_namespace = 'user.services'
  end

  load_paths!('lib')
  auto_register!('lib')
end

# lib/user/services/email_sender.rb
module User
  module Services
    class EmailSender
      # sending email logic
    end
  end
end

# the email sender services becomes available
Application['email_sender']
```
