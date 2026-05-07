ARG RUBY_VERSION=3.3.0
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails
ENV RAILS_ENV=production BUNDLE_DEPLOYMENT=1 BUNDLE_PATH=/usr/local/bundle BUNDLE_WITHOUT=development

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential libpq-dev curl libjemalloc2 && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN bundle exec bootsnap precompile app/ lib/

EXPOSE 3000
CMD ["./bin/thrust", "./bin/rails", "server"]
