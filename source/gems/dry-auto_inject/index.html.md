---
title: Introduction
description: Container-agnostic dependency resolution mixin
layout: gem-single
order: 4
type: gem
name: dry-auto_inject
sections:
  - usage
---

`dry-auto_inject` is designed to provide low-impact dependency resolution, it was originally implemented to complement [dry-container](/gems/dry-container/), however, it is completely container-agnostic and will resolve dependencies from any container that responds to the `#[]` interface.
