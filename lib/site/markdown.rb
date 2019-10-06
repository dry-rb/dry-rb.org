# frozen_string_literal: true

require 'middleman/docsite/markdown/renderer'
require 'site/helpers'

module Site
  module Markdown
    class Renderer < Middleman::Docsite::Markdown::Renderer
      include Helpers

      def link(title, path, target)
        if target.start_with?('docs::')
          *, section = target.split('::')
          link_to_docs(section, title)
        else
          super
        end
      end

      def link_to_docs(section, title)
        path = ['gems', project.name, version, section].join('/')
        scope.link_to(title, path)
      end

      def version
        scope.current_version
      end

      def project
        scope.current_project
      end
    end
  end
end
