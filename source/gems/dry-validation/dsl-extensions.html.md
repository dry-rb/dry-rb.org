---
title: DSL Extensions
layout: gem-single
name: dry-validation
---

As mentionned [here][0], it's possible to extend the DSL.
Have a look at [the spec][1] for more examples.

```ruby
module MyMacros
  def maybe_int(name, *predicates, &block)
    required(name).maybe(:int?, *predicates, &block)
  end
end

Dry::Validation::Schema.configure do |config|
  config.dsl_extensions = MyMacros
end

Dry::Validation.Schema do
  maybe_int(:age, gt?: 18)
end
```

[0]: https://github.com/dry-rb/dry-rb.org/blob/04a0fbfb2ba77cc2294d9ad52d1a04750343e940/source/news/2016-07-01.html.markdown#extendible-dsl
[1]: https://github.com/dry-rb/dry-validation/blob/7d2231130fb08f5756ec285aad8885ab2cd93cab/spec/integration/schema/extending_dsl_spec.rb
