# Base image
FROM ruby:3.2.2-slim-buster as base
LABEL org.opencontainers.image.authors="pokorny@luk4s.cz"
# Setup environment variables that will be available to the instance
ENV RAILS_ROOT /app
# Installation of dependencies
RUN apt-get update -qq \
  && apt-get install -y vim curl firefox-esr \
# Needed for certain gems
    build-essential \
# Needed for postgres gem
    libpq-dev \
# https://github.com/mimemagicrb/mimemagic
    shared-mime-info \
# The following are used to trim down the size of the image by removing unneeded data
  && apt-get clean autoclean \
  && apt-get autoremove -y
RUN gem install bundler --no-document --version 2.5.6
# Create a directory for our application
# and set it as the working directory
WORKDIR "${RAILS_ROOT}"
# Add our Gemfile
# and install gems
COPY Gemfile* ./
RUN bundle config set deployment 'true' && \
    bundle install --jobs $(nproc) --retry 5

FROM base as assets
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get update && apt-get install -y nodejs
# Copy over our application code
COPY . .
RUN bundle exec rails assets:precompile

FROM base
ENV RAILS_ENV "production"
COPY --from=assets /app .
RUN ln -s "${RAILS_ROOT}/bin/geckodriver" /usr/local/bin/

RUN useradd rails --create-home --shell /bin/bash && \
    mkdir -p db log storage tmp coverage && \
    chown -R rails:rails db log storage tmp coverage
USER rails:rails

EXPOSE 3000/tcp
ENTRYPOINT ["./bin/docker-entrypoint.sh"]
CMD ["start"]
