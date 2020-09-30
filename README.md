[chat]: https://dry-rb.zulipchat.com
## An Amazing Project
# dry-rb.org [![Join the chat at https://dry-rb.zulipchat.com](https://img.shields.io/badge/dry--rb-join%20chat-%23346b7a.svg)][chat]

![ci](https://github.com/dry-rb/dry-rb.org/workflows/ci/badge.svg)

This is the [Middleman](https://middlemanapp.com)-generated [dry-rb.org website](http://dry-rb.org/).

## Getting started

Install the gem and NPM dependencies:

```
bundle install
npm install
```

Clone and symlink docsites from individual dry-rb repositories:

```
bundle exec projects:symlink
```

Start Middleman server:

```
bundle exec middleman s
```

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md).
