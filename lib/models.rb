require 'dry-initializer'
require 'yaml'

module Site
  def self.projects
    @projects ||= Factory.new(Project, YAML.load_file(data_path.join('projects.yaml')))
  end

  def self.data_path
    root.join('data')
  end

  def self.root
    @root ||= Pathname(__dir__).join('..')
  end
end

class Factory
  extend Dry::Initializer
  extend Forwardable

  param :klass
  param :data

  def respond_to?(method, include_private = false)
    super || Array.method_defined?(method) || klass.respond_to?(method, include_private)
  end

  def method_missing(method, *args, &block)
    if klass.respond_to?(method)
      args = args.push(self)
      klass.send(method, *args, &block)
    elsif Array.method_defined?(method)
      self.class.def_delegator :to_a, method
      to_a.send(method, *args, &block)
    else
      super
    end
  end

  def to_a
    @objects ||= data.map do |attrs|
      attrs = attrs.inject({}){ |memo,(k,v)| memo[k.to_sym] = v; memo }
      klass.new(attrs)
    end
  end
  alias :all :to_a
end

class Project
  extend Dry::Initializer

  option :name
  option :desc
  option :versions, optional: true, default: proc { Array.new }
  option :current_version, optional: true
  option :fallback_version, optional: true

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
# end
