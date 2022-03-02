#!/bin/bash -l
set -e

install() {
  bundle exec rails db:migrate RAILS_ENV=production
}
sidekiq() {
  bundle exec sidekiq -e "${RAILS_ENV}"
}
server() {
  bundle exec puma -e "${RAILS_ENV}" -p 3000
}
case "$1" in
  "install")
    install
    ;;
  "server")
    server
    ;;
  "sidekiq")
    sidekiq
    ;;
  "start")
    install && server
    ;;
  *)
    echo "Unknown action. Use install, server or sidekiq."
    exit 1
    ;;
esac
