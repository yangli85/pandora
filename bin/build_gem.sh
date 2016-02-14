#!/bin/bash
RUBY_VERSION=$(grep -o -E "[0-9]+([.][0-9]+){1,2}" .ruby-version)
echo "Looking for ruby version ${RUBY_VERSION}"

[[ -f /usr/share/chruby/chruby.sh ]] && source /usr/share/chruby/chruby.sh
chruby ruby-${RUBY_VERSION}
echo "Using ruby version $(ruby -v) from $(type ruby)"

export GEM_VERSION="1.0"
gem install bundler_geminabox
rake build

gem inabox pkg/*.gem --host "http://101.200.162.121:9292"
