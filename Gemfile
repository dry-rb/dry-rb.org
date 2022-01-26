source "https://rubygems.org"

gem "rake"

# For feed.xml.builder
gem "builder", "~> 3.0"

# Middleman
gem "middleman", "~> 5.0.0.rc.2", github: "middleman/middleman" # Remove github source when rc.2 is released (See: middleman/middleman#2524)
gem "middleman-dotenv"
gem "middleman-minify-html"
gem "middleman-blog"
gem "middleman-syntax"
#gem "middleman-docsite", github: "solnic/middleman-docsite"
gem "middleman-docsite", github: "cllns/middleman-docsite", branch: "cllns/update-gems" # Remove once solnic/middleman-docsite#7 is merged

# Middleman extra deps
gem "better_errors"
gem "hashugar"
gem "sanitize"
# Formats
gem "redcarpet"
gem "slim"
gem "tilt-jbuilder"

# Checks html markup
gem "html-proofer"

# Misc
group :development do
  gem "puma"
  gem "binding_of_caller"
  gem "mime-types"
  gem "rack-contrib"
  gem "byebug", require: false, platform: :mri
end
