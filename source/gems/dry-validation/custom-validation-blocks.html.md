---
title: Custom Validation Blocks
layout: gem-single
---

Just like [high-level rules](/gems/dry-validation/high-level-rules.html), custom validation blocks are executed only when the values they depend on are valid. You can define these blocks using `validate` DSL, they will be executed in the context of your schema objects, which means schema collaborators or external configurations are accessible within these blocks. 

``` ruby
UserSchema = Dry::Validation.Form do
  configure do
    option :ids

    def self.messages
      super.merge(
        en: { errors: { valid_id: 'id is not valid' } }
      )
    end
  end

  required(:id).filled(:int?)

  validate(valid_id: :id) do |id|
    ids.include?(id)
  end
end

schema = UserSchema.with(ids: [1, 2, 3])

schema.(id: 4).errors
# {:valid_id=>["id is not valid"]}
```
