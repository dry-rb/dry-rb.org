# frozen_string_literal: true

require 'middleman/docsite/project'

module Site
  class Project < Middleman::Docsite::Project
    attribute(:name, Types::String)
    attribute(:popularity, Types::Integer.constrained(gteq: 1, lteq: 5))
    attribute(:desc, Types::String)
    attribute(:seo, Types.Hash(description: Types::String).with_key_transform(&:to_sym))

    alias to_s name

    def repo
      "https://github.com/#{org}/#{name}.git"
    end

    def latest_path
      "/gems/#{name}/#{latest_version}"
    end

    def latest_version
      version = versions
        .reject { |version| version[:value].eql?('master') }
        .max_by { |version| Gem::Version.new(version[:value]) }

      version ? version[:value] : 'master'
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
