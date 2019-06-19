require 'rubygems'
require 'bundler'
Bundler.setup

require 'middleman'
require 'rack/contrib/try_static'

use Rack::Deflater

# Serve anything out of /build
use Rack::TryStatic, :root => "build", :urls => %w[/], :try => ['.html', 'index.html', '/index.html']

# Run the middleman server for everything else
run Middleman.server
