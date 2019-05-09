---
title: Configuration
layout: gem-single
name: dry-validation
---

Contract classes can be configured using `config` object. Typically, it is recommended to define an abstract contract class that other classes will inherit from. This way you can share common configuration between many contracts with no duplication.

### Accessing configuration

Use `Contract.config` to access configuration and set its values:

``` ruby
class ApplicationContract < Dry::Validation::Contract
  config.locale = :pl
end
```

Now any class that inherits from `ApplicationContract` will have the same configuration:

``` ruby
class UserContract < ApplicationContract
end

UserContract.config.locale
# :pl
```

### Configuration settings

You can configure following settings:

- `config.messages.top_namespace` - the key in locales files under which messages are defined, by default it's `dry_validation`
- `config.messages.backend` - which localization backend should be used. Supported values are: `:yaml` and `:i18n`
- `config.messages.load_paths` - an array with file paths that are used to load messages
- `config.messages.namespace` - custom messages namespace for a contract class, use this to override common messages
- `config.locale` - default `I18n`-compatible locale identifier

### Example

Let's say we want to configure a contract class to load messages from a custom file and use our own `top_namespace`. Our file will look like this:

```yaml
# config/errors.yml
en:
  my_app:
    errors:
      taken: 'is already taken'
```

If you want your contract classes to use `my_app` as your own top-level namespace and pull in custom messages, use following configuration:

``` ruby
class ApplicationContract < Dry::Validation::Contract
  config.messages.top_namespace = :my_app
  config.messages.load_paths << 'config/errors.yml'
end
```
