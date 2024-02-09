# Start with a Ruby base image
FROM ruby:2.6

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

# Set working directory
WORKDIR /app

# Copy project files
COPY Gemfile Gemfile.lock package.json package-lock.json ./

# Update rubygems
RUN gem update --system 3.2.3

# Install bundler that works with the current version of Ruby
RUN gem install bundler:2.4.22 --no-document
