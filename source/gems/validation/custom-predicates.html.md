---
title: Custom Predicates
layout: gem-single
order: 9
group: dry-validation
---

## Custom Predicates

You can simply define predicate methods on your schema object:

``` ruby
class Schema < Dry::Validation::Schema
  key(:email) { |value| value.str? & value.email? }

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

class Schema < Dry::Validation::Schema
  configure do |config|
    config.predicates = MyPredicates
  end

  key(:email) { |value| value.str? & value.email? }
end
```

You need to provide error messages for your custom predicates if you want them to work with `Schema#call(input).messages` interface.

You can learn how to do that in the [Error Messages](/gems/validation/error-messages) section.
