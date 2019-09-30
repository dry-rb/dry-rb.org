# frozen_string_literal: true

require 'middleman/docsite/project'

module Site
  class Project < Middleman::Docsite::Project
    attribute(:name, Types::String)
    attribute(:desc, Types::String)
    attribute?(:versions, Types::Array.default { [] })
    attribute?(:current_version, Types::String)
    attribute?(:fallback_version, Types::String)

    alias_method :to_s, :name

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

    def github_url
      "https://github.com/dry-rb/#{name}"
    end

    def rubygems_url
      "https://rubygems.org/gems/#{name}"
    end

    def version_badge
      "https://img.shields.io/gem/v/#{name}.svg?style=flat"
    end

    def ci_badge
      "https://img.shields.io/travis/dry-rb/#{name}/master.svg?style=flat"
    end

    def codeclimate_url
      "https://codeclimate.com/github/dry-rb/#{name}"
    end

    def codeclimate_badge
      "https://codeclimate.com/github/dry-rb/#{name}/badges/gpa.svg"
    end

    def coverage_badge
      "https://codeclimate.com/github/dry-rb/#{name}/badges/coverage.svg"
    end

    def inch_url
      "http://inch-ci.org/github/dry-rb/#{name}"
    end

    def inch_badge
      "http://inch-ci.org/github/dry-rb/#{name}.svg?branch=master&style=flat"
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
  end
end