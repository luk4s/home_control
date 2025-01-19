# Base image
FROM ruby:3.3.7-slim-bookworm AS base
LABEL org.opencontainers.image.authors="pokorny@luk4s.cz"
# Setup environment variables that will be available to the instance
ENV RAILS_ROOT=/app
# Installation of dependencies
RUN apt update -qq \
  && apt install -y vim curl firefox-esr \
# Needed for certain gems
    build-essential \
# Needed for postgres gem
    libpq-dev \
# https://github.com/mimemagicrb/mimemagic
    shared-mime-info \
# The following are used to trim down the size of the image by removing unneeded data
  && apt clean autoclean \
  && apt autoremove -y
RUN gem install bundler --no-document --version 2.5.22
# Create a directory for our application
# and set it as the working directory
WORKDIR "${RAILS_ROOT}"
# Add our Gemfile
# and install gems
COPY Gemfile* ./
RUN bundle config set deployment 'true' && \
    bundle install --no-cache --jobs $(nproc) --retry 5

FROM base AS assets
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
RUN apt update && \
    apt install -y nodejs && \
    corepack enable && \ 
    yarn set version classic

# Copy over our application code
COPY . .
RUN bundle exec rails assets:precompile

FROM base
ENV RAILS_ENV="production"
RUN ln -s "${RAILS_ROOT}/bin/geckodriver" /usr/local/bin/
COPY . .
COPY --from=assets /app/public /app/public

RUN useradd rails --create-home --shell /bin/bash && \
    mkdir -p db log storage tmp coverage && \
    chown -R rails:rails db log storage tmp coverage
USER rails:rails

EXPOSE 3000/tcp
ENTRYPOINT ["./bin/docker-entrypoint.sh"]
CMD ["start"]
