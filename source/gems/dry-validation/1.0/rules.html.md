---
title: Rules
layout: gem-single
name: dry-validation
---

Rules in contracts are meant to perform domain-specific validation of data that was already processed by contract's schema. This way you can define rules that can focus purely on their validation logic without having to worry about type-related details.

When you apply a contract, it will process input using its schema, and then apply rules one-by-one, in the same order that you defined them.

> If a rule specifies that it depends on specific keys in the input, it **will be executed only when schema successfuly processed values under those keys**

### Defining a rule

To define a rule on a contract, simply use `rule` method. Let's say we want to validate if an event's start date is in the future. We'll define a contract for event data with a `start_date` key that must be provided as a valid `Date` object. Then we'll define a rule that will check that it's in the future:

```ruby
class EventContract < Dry::Validation::Contract
  params do
    required(:start_date).value(:date)
  end

  rule(:start_date) do
    key.failure('cannot set past date') if values[:start_date] <= Date.today
  end
end

contract = EventContract.new
```

Notice that if you apply your contract with an input that doesn't include a date under `start_date` key, your rule **will not be executed**:

```ruby
contract.call(start_date: 'oops').errors.to_h
# => {:start_date=>["must be a date"]}
```

When `start_date` is a `Date`, the rule will be executed:

```ruby
contract.call(start_date: Date.today - 1).errors.to_h
# => {:start_date=>["cannot set past date"]}
```

### Depending on more than one key

In our previous example, we defined a simple rule that depends on a single key. Now let's take a look how you can depend on more than one key. To achieve this, you can specify a list of keys. Let's extend previous example with another rule that will check if `end_date` is after the `start_date`:

```ruby
class EventContract < Dry::Validation::Contract
  params do
    required(:start_date).value(:date)
    required(:end_date).value(:date)
  end

  rule(:end_date, :start_date) do
    key.failure('must be after end date') if values[:end_date] >= values[:start_date]
  end
end

contract = EventContract.new

contract.call(start_date: Date.today, end_date: Date.today - 1).errors.to_h
# => {:end_date=>["must be after start date"]}
```

### Key path syntax

When you define key dependencies for rules, you use *the key path syntax*. Here's a list of supported key paths:

- Using a hash: `rule(address: :city) do ...`
- The same, but using *dot notation*: `rule("address.city") do ...`
- Specifying multiple nested keys using a hash: `rule(address: [:city, :street]) do ...`

### Key failures

The only responsibility of a rule is to set a failure message when validation didn't pass. In the previous examples we used `key.failure` syntax to manually set messages, use it if you want to set a failure message that should be accessible under a specific key.

By default, it uses *the first key defined by the rule* when you use it without any arguments:

``` ruby
rule(:start_date) do
  key.failure('oops')
  # ^ is the equivalent of
  key(:start_date).failure('oops')
end
```

You *do not have to use keys that match keys in the input*. For example this is perfectly fine:

``` ruby
rule(:start_date) do
  key(:event_errors).failure('oops')
end
```

### Using localized messages backend

If you enabled `:i18n` or `:yaml` messages backend in the [configuration](/gems/dry-validation/configuration), you can define messages in a yaml file and use their identifiers instead of plain strings. Here's a sample yaml with a message for our `start_date` error:

```yaml
en:
  dry_validation:
    errors:
      rules:
        end_date:
          invalid: 'must be after start date'
```

Now, assuming you [configured your contract to use a custom messages file](/gems/dry-validation/1.0.0/configuration#example), we can write this:

```ruby
rule(:start_date, :end_date) do
  key.failure(:invalid) if values[:end_date] >= values[:start_date]
end
```

### Base failures

Unlike key failures, base failures are not associated with a specific key, instead they are associated with the whole input. To set a base failure, simply use `base` method, that has the same API as `key`. Here's an example:

``` ruby
class EventContract < Dry::Validation::Contract
  option :today, default: Date.method(:today)

  params do
    required(:start_date).value(:date)
    required(:end_date).value(:date)
  end

  rule do
    if today.saturday? || today.sunday?
      base.failure('creating events is allowed only on weekdays')
    end
  end
end

contract = EventContract.new
```

Now when you try to apply this contract during a weekend, you'll get a base error:

``` ruby
contract.call(start_date: Date.today+1, end_date: Date.today+2).errors.to_h
# => {nil=>["creating events is allowed only on weekdays"]}
```

Notice that the hash representation includes `nil` key, this indicates base errors. There's also a nice API for finding all base errors, if you prefer that:

``` ruby
contract.call(start_date: Date.today+1, end_date: Date.today+2).errors.filter(:base?).map(&:to_s)
# => ["creating events is allowed only on weekdays"]
```

> Curious about that `option` method that we used to set `today` value? You can learn about it in [the external dependencies](/gems/dry-validation/external-dependencies) section.