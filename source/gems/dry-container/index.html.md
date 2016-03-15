---
title: Introduction
description: Simple, thread-safe container
layout: gem-single
order: 3
type: gem
name: dry-container
sections:
  - usage
---

`dry-container` is a simple, thread-safe container, intended to be one half of the implementation of an [IoC](https://en.wikipedia.org/wiki/Inversion_of_control) container, when combined with [dry-auto_inject](/gems/dry-auto_inject/), this gem allows you to make use of the [dependency inversion principle](https://en.wikipedia.org/wiki/Dependency_inversion_principle), which would normally be ignored in *idiomatic* Ruby libraries in favour of hard-coded dependencies and/or wide interfaces.

Making use of the dependency inversion principle, with an IoC container and low-impact dependency resolution, allows you to follow many of the principles and practices that have been considered beneficial in software engineering for decades, such as SOLID. This is mostly because your objects (and their behaviour) can easily be composed of other small objects with narrow interfaces, and prividing you code to an interface, these dependencies can easily be swapped out later by simply registering a different object with the container.
