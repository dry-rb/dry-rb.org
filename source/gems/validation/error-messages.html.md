---
title: Error Messages
layout: gem-single
order: 8
group: dry-validation
---

## Error Messages

By default `dry-validation` comes with a set of pre-defined error messages for every built-in predicate. They are defined in [a yaml file](https://github.com/dryrb/dry-validation/blob/master/config/errors.yml) which is shipped with the gem. This file is compatible with `I18n` format.

You can provide your own messages and configure your schemas to use it like that:

``` ruby
class Schema < Dry::Validation::Schema
  configure { |config| config.messages_file = '/path/to/my/errors.yml' }
end
```

You can also provide a namespace per-schema that will be used by default:

``` ruby
class Schema < Dry::Validation::Schema
  configure { |config| config.namespace = :user }
end
```

Lookup rules:

``` yaml
en:
  errors:
    size?:
      arg:
        default: "%{name} size must be %{num}"
        range: "%{name} size must be within %{left} - %{right}"

      value:
        string:
          arg:
            default: "%{name} length must be %{num}"
            range: "%{name} length must be within %{left} - %{right}"

    filled?: "%{name} must be filled"

    rules:
      email:
        filled?: "the email is missing"

      user:
        filled?: "%{name} name cannot be blank"

        rules:
          address:
            filled?: "You gotta tell us where you live"
```

Given the yaml file above, messages lookup works as follows:

``` ruby
messages = Dry::Validation::Messages.load('/path/to/our/errors.yml')

# matching arg type for size? predicate
messages[:size?, rule: :name, arg_type: Fixnum] # => "%{name} size must be %{num}"
messages[:size?, rule: :name, arg_type: Range] # => "%{name} size must within %{left} - %{right}"

# matching val type for size? predicate
messages[:size?, rule: :name, val_type: String] # => "%{name} length must be %{num}"

# matching predicate
messages[:filled?, rule: :age] # => "%{name} must be filled"
messages[:filled?, rule: :address] # => "%{name} must be filled"

# matching predicate for a specific rule
messages[:filled?, rule: :email] # => "the email is missing"

# with namespaced messages
user_messages = messages.namespaced(:user)

user_messages[:filled?, rule: :age] # "%{name} cannot be blank"
user_messages[:filled?, rule: :address] # "You gotta tell us where you live"
```

By configuring `messages_file` and/or `namespace` in a schema, default messages are going to be automatically merged with your overrides and/or namespaced.

## I18n Integration

If you are using `i18n` gem and load it before `dry-validation` then you'll be able to configure a schema to use `i18n` messages:

``` ruby
require 'i18n'
require 'dry-validation'

class Schema < Dry::Validation::Schema
  configure { config.messages = :i18n }

  key(:email, &:filled?)
end

schema = Schema.new

# return default translations
puts schema.call(email: '').messages
{ :email => ["email must be filled"] }

# return other translations (assuming you have it :))
puts schema.call(email: '').messages(locale: :pl)
{ :email => ["email musi być wypełniony"] }
```

Important: I18n must be initialized before using schema, `dry-validation` does not try to do it for you, it only sets its default error translations automatically.
