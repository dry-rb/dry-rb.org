---
title: Templates
layout: gem-single
---

Every view controller has a template, which receives its data and generates the view output.

Save your template in one of the `paths` configured in your view controller.

Templates follow a 3-part naming scheme: `<name>.<format>.<engine>`:

- `name` matches the view controller's `name` configuration.
- `format` is for matching the template with the view controller's format.
- `engine` is the rendering engine to use with the template.

An example is `index.html.slim`, which would be found for a view controller with a `name` of "index" and a `default_format` of "html". This template would be rendered with [Slim](http://slim-lang.com).

dry-view uses [Tilt](https://github.com/rtomayko/tilt) to render its templates, and relies upon Tilt's auto-detection of rendering engine based on the template file's extension. However, you should be sure to explicitly `require` any engine gems that you intend to use.

## Scope

Each template is rendered with its own _scope_, which determines the methods available within the template. The scope is made from two things: the data from the [exposures](/gems/dry-view/exposures/), and the [context object](/gems/dry-view/context/).

The template scope evaluates methods sent to it in this order:

- If there is a matching exposure, it is returned
- If the context object responds to the method, it is called, along with any arguments passed to the method
- If none of the above match, it attempts to render a partial

For example:

```slim
/ `#content_for` is available on our context object
- content_for :title, "Users list"

/ `#users` is provided via an exposure
- users.each do |user|
  p = user.name

/ `#pagination` is not an exposure or in the context, so renders a partial
== pagination records: users
```

## Partials

### Template lookup

Partials are rendered by calling their name on the template scope (see `pagination` in the the example above). The template for a partial is prefixed by an underscore, and searched for in 2 specific places:

- `<template_name>/<partial_name>`
- `shared/<partial_name>`

So, for a `pagination` partial rendered from within an `users/index.html.slim` template, the partial would be searched for in:

- `users/index/_pagination.html.slim`
- `users/shared/_pagination.html.slim`

If a matching template is not found in those locations, the search is repeated in the parent directory:

- `users/_pagination.html.slim`
- `users/shared/_pagination.html.slim`

This is repeated until the root of the templates path is reached.

### Scope

A partial called with no arguments is rendered with the same scope as its parent template. This is useful for breaking larger templates up into smaller chunks for readability. For example:

```slim
h1 About us

/ Split this template into 3 partials, all sharing the same scope
== introduction
== location
== contact_form
```

Otheriwse, partials accept keywords arguments, which become a new scope for rendering the partial. For example:

```slim
h1 Our team

- people.each do |person|
  / Render `persion_info` partial with only `person` in the scope
  == person_info person: person
```

The view controller's context object remains part of the scope for every partial, regardless of whether any arguments are passed.
