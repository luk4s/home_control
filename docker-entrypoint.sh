#!/bin/bash -l
set -e

install() {
    bundle exec rails db:setup RAILS_ENV=production
}
server() {
    bundle exec puma -e "${RAILS_ENV}" -p 3000 -b 0.0.0.0
}
case "$1" in
  "install")
    install
    ;;
  "server")
    server
    ;;
  "start")
    install && server
    ;;
  *)
    echo "Unknown action. Use install, server or sidekiq."
    exit 1
    ;;
esac
