#!/bin/bash
if [[ -z "$RACK_ENV" || "$RACK_ENV" != "production" ]]; then
  bundle exec shotgun --server=puma --port=4567
else
  bundle exec puma -d -b tcp://127.0.0.1:4567 --pidfile /tmp/puma.pid
fi
