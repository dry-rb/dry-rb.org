---
title: Custom Predicates
layout: gem-single
order: 9
group: dry-validation
---

You can simply define predicate methods on your schema object:

``` ruby
schema = Dry::Validation.Schema do
  key(:email).required(:str?, :email?)

  def email?(value)
    ! /magical-regex-that-matches-emails/.match(value).nil?
  end
end
```

You can also re-use a predicate container across multiple schemas:

``` ruby
module MyPredicates
  include Dry::Logic::Predicates

  predicate(:email?) do |value|
    ! /magical-regex-that-matches-emails/.match(value).nil?
  end
end

schema = Dry::Validation.Schema do
  configure do
    config.predicates = MyPredicates
  end

  key(:email).required(:str?, :email?)
end
```

You need to provide error messages for your custom predicates if you want them to work with `Schema#call(input).messages` interface.

You can learn how to do that in the [Error Messages](/gems/validation/error-messages) section.
