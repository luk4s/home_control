# Base image
FROM ruby:3.3.7-slim-bookworm AS base
LABEL org.opencontainers.image.authors="pokorny@luk4s.cz"
# Setup environment variables that will be available to the instance
ENV RAILS_ROOT=/app
# Installation of dependencies
RUN apt update -qq \
  && apt install -y vim curl firefox-esr \
    build-essential libpq-dev libyaml-dev \
    && apt clean autoclean \
  && apt autoremove -y
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
