# # syntax=docker/dockerfile:1
# # check=error=true

# # This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# # docker build -t cf_storage .
# # docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name cf_storage cf_storage

# # For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# # Make sure RUBY_VERSION matches the Ruby version in .ruby-version
# ARG RUBY_VERSION=3.4.6
# FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# # Rails app lives here
# WORKDIR /rails

# # Install base packages
# RUN apt-get update -qq && \
#     apt-get install --no-install-recommends -y curl default-mysql-client libjemalloc2 libvips && \
#     rm -rf /var/lib/apt/lists /var/cache/apt/archives

# # Set production environment
# ENV RAILS_ENV="production" \
#     BUNDLE_DEPLOYMENT="1" \
#     BUNDLE_PATH="/usr/local/bundle" \
#     BUNDLE_WITHOUT="development"

# # Throw-away build stage to reduce size of final image
# FROM base AS build

# # Install packages needed to build gems
# RUN apt-get update -qq && \
#     apt-get install --no-install-recommends -y build-essential default-libmysqlclient-dev git libyaml-dev pkg-config && \
#     rm -rf /var/lib/apt/lists /var/cache/apt/archives

# # Install application gems
# COPY Gemfile Gemfile.lock ./
# RUN bundle install && \
#     rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
#     bundle exec bootsnap precompile --gemfile

# # Copy application code
# COPY . .

# # Precompile bootsnap code for faster boot times
# RUN bundle exec bootsnap precompile app/ lib/

# # Adjust binfiles to be executable on Linux
# RUN chmod +x bin/* && \
#     sed -i "s/\r$//g" bin/* && \
#     sed -i 's/ruby\.exe$/ruby/' bin/*

# # Precompiling assets for production without requiring secret RAILS_MASTER_KEY
# RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile




# # Final stage for app image
# FROM base

# # Copy built artifacts: gems, application
# COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
# COPY --from=build /rails /rails

# # Run and own only the runtime files as a non-root user for security
# RUN groupadd --system --gid 1000 rails && \
#     useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
#     chown -R rails:rails db log storage tmp
# USER 1000:1000

# # Entrypoint prepares the database.
# ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# # Start server via Thruster by default, this can be overwritten at runtime
# EXPOSE 80
# CMD ["./bin/thrust", "./bin/rails", "server"]

# Base image Ruby
FROM ruby:3.4

# Thư mục chứa app
WORKDIR /app

# Environment
ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

# Cài system dependencies + Node + npm
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        build-essential \
        git \
        curl \
        nodejs \
        npm \
        libpq-dev \
        libsqlite3-dev \
        libvips && \
    rm -rf /var/lib/apt/lists/*

# Copy Gemfile trước để cache bundle
COPY Gemfile Gemfile.lock ./

# Cài gems
RUN bundle install

# Copy toàn bộ source code
COPY . .

# Fix CRLF + ruby.exe in bin scripts for Linux compatibility
RUN find ./bin -type f -exec sed -i 's/\r$//' {} \; && \
chmod +x ./bin/*


# Expose port Rails
EXPOSE 8000

# Lệnh chạy Rails server
CMD ["bash", "-c", "bin/rails server -b 0.0.0.0 -p 8000"]
