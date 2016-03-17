---
title: Introduction
layout: gem-single
name: dry-component
type: gem
sections:
  - container
  - auto-import
  - booting-a-dependency
  - environment-and-options
---

Dependency management system based on [dry-container](/gems/dry-container) and [dry-auto_inject](/gems/dry-auto_inject) allowing you to configure reusable components in any environment, set up their load-paths, require needed files and instantiate objects automatically with the ability to have them injected as dependencies.

Originally built for [rodakase](https://github.com/solnic/rodakase) stack, now as a standalone, small library.

This is a simple system that relies on very basic mechanisms provided by Ruby, specifically `require` and managing `$LOAD_PATH`. It does not rely on any magic like automatic const resolution, it's pretty much the opposite and forces you to be explicit about dependencies in your applications.

It does a couple of things for you that are really not something you want to do yourself:

* Provides an abstract dependency container implementation
* Handles `$LOAD_PATH` configuration
* Loads needed files using `require`
* Resolves dependencies automatically
* Supports auto-registration of dependencies via file/dir naming conventions
* Provides support for custom configuration loaded from external sources (ie YAML)

To put it all together, this allows you to configure your system in a way where you have full control over dependencies and it's very easy to draw the boundaries between individual components.

This comes with a bunch of nice benefits:

* Your system relies on abstractions rather than concrete classes and modules
* It helps in decoupling your code from 3rd party code
* It makes it possible to load components in complete isolation. In example you can run a single test for a single component and only required files will be loaded, or you can run a rake task and it will only load the things it needs.
* It opens up doors to better instrumentation and debugging tools
