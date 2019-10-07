# frozen_string_literal: true

require 'middleman/docsite/markdown/renderer'
require 'site/helpers'

module Site
  module Markdown
    class Renderer < Middleman::Docsite::Markdown::Renderer
      include Helpers

      def link(title, path, label)
        if title.start_with?('docs::')
          *, section = title.split('::')
          link_to_docs(section, label)
        else
          super
        end
      end

      def link_to_docs(section, label)
        path = ['/gems', project.name, version, section].join('/')
        scope.link_to(label, path)
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
