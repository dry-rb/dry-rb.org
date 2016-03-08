---
title: Gem 1
description: A short description about gem 1
layout: gem-single
type: gem
---

## Getting started

Many Rubyists start their journey being exposed to Rails and its favored object relational mapping (ORM) library, `Active Record`. `Active Record` is an implementation of the Active Record pattern. In this pattern, objects carry the data and the behavior that operates on that data.

The `Active Record` pattern has been widely adopted by the Ruby community, mostly due to the success of Rails; however, it’s a pattern with well known shortcomings. In complex applications, `Active Record` is no longer a good choice as it tightly couples your application’s domain layer with the underlying database. It’s especially problematic in Rails where its `ActiveRecord` ORM provides a gigantic interface to handle many different concerns. As a result, many Rails applications suffer from rapidly increasing complexity, caused by internal coupling and lack of a clean domain layer, to a point where maintaining and growing an application becomes very difficult.

	require 'rom-repository'  # repository makes simple operations easy

	# ... and don't forget adapters
		require 'rom-sql'         # use this if you installed sql adapter
		require 'rom-http'        # and this for http
		require 'rom-couchdb'     # ... etc
