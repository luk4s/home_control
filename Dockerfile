# Base image
FROM ruby:3.2.2-slim-buster
LABEL org.opencontainers.image.authors="pokorny@luk4s.cz"
# Setup environment variables that will be available to the instance
ENV RAILS_ROOT /app
# Setting env up
ENV RAILS_ENV "production"
# Installation of dependencies
RUN apt-get update -qq \
  && apt-get install -y vim curl nodejs firefox-esr \
# Needed for certain gems
    build-essential \
# Needed for postgres gem
    libpq-dev \
# https://github.com/mimemagicrb/mimemagic
    shared-mime-info \
# The following are used to trim down the size of the image by removing unneeded data
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf \
    /var/lib/apt \
    /var/lib/dpkg \
    /var/lib/cache \
    /var/lib/log
RUN gem install bundler --no-document --version 2.5.6
# Create a directory for our application
# and set it as the working directory
RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT
# Add our Gemfile
# and install gems
COPY Gemfile* ./
RUN bundle config set deployment 'true' && \
    bundle install --jobs $(nproc) --retry 5
# Copy over our application code
COPY . .
RUN ln -s $RAILS_ROOT/bin/geckodriver /usr/local/bin/

EXPOSE 3000/tcp
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["start"]
