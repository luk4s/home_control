# Base image
FROM ruby:3.4.7-alpine AS base
LABEL org.opencontainers.image.authors="pokorny@luk4s.cz"
# Setup environment variables that will be available to the instance
ENV RAILS_ROOT=/app
# Installation of dependencies (Alpine uses apk instead of apt)
RUN apk update && \
    apk add --no-cache \
    vim curl \
    build-base postgresql-dev yaml-dev \
    tzdata gcompat libffi-dev pkgconfig \
    && rm -rf /var/cache/apk/*
# and set it as the working directory
WORKDIR "${RAILS_ROOT}"
# Add our Gemfile
# and install gems
COPY Gemfile* ./
RUN bundle config set deployment 'true' && \
    bundle install --no-cache --jobs $(nproc) --retry 5

FROM base AS assets
# For Node.js installation in Alpine
RUN apk add --no-cache nodejs yarn

# Copy over our application code
COPY . .
RUN bundle exec rails assets:precompile

FROM base
ENV RAILS_ENV="production"
COPY . .
COPY --from=assets /app/public /app/public

RUN adduser -h /home/rails -s /bin/sh -D rails && \
    mkdir -p db log storage tmp coverage && \
    chown -R rails:rails db log storage tmp coverage
USER rails:rails

EXPOSE 3000/tcp
ENTRYPOINT ["./bin/docker-entrypoint.sh"]
CMD ["start"]