# frozen_string_literal: true

require 'middleman/docsite/markdown/renderer'
require 'site/helpers'

module Site
  module Markdown
    class Renderer < Middleman::Docsite::Markdown::Renderer
      include Helpers
    end
  end
end
