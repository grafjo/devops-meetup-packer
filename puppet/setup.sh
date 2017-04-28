#!/bin/bash

if [[ ! -e /usr/bin/bundle && ! -e /usr/local/bin/bundle ]]
then
    echo "please install bundler!"
    exit 1
fi

echo "==> installing librarian-puppet"
bundle install --path vendor/bundle

echo "==> running librarian-puppet"
bundle exec librarian-puppet install

echo "==> finished running librarian-puppet"
