# frozen_string_literal: true

require 'middleman/docsite/project'

module Site
  class Project < Middleman::Docsite::Project
    attribute(:name, Types::String)
    attribute(:desc, Types::String)
    attribute?(:current_version, Types::String)
    attribute?(:fallback_version, Types::String)

    # Convert this config:
    #
    # versions:
    # - "0.4"
    # - code: "1.0"
    #   name: "1.0 beta3"
    #
    # into this:
    #
    # [{code: "0.4", name: "0.4"}, {code: "1.0", name: "1.0 beta3"}]
    def version_variants
      versions.map do |version|
        if version.is_a?(String)
          { code: version, name: version }
        else
          { code: version['code'], name: version['name'] }
        end
      end
    end

    def opened_issues_badge
      "https://img.shields.io/github/issues/dry-rb/#{name}.svg?branch=master&style=flat"
    end

    def opened_issues_url
      "#{github_url}/issues"
    end

    def opened_pulls_badge
      "https://img.shields.io/github/issues-pr/dry-rb/#{name}.svg?branch=master&style=flat"
    end

    def opened_pulls_url
      "#{github_url}/pulls"
    end

    def org
      'dry-rb'
    end
  end
end
