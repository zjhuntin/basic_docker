#!/bin/bash

cd /tmp

git clone https://github.com/theforeman/foreman.git

mv database.yml /tmp/foreman/config

git clone https://github.com/Katello/katello.git
cd foreman

cp config/settings.yaml.example config/settings.yaml
sed -i 's/:locations_enabled: false/:locations_enabled: true/' config/settings.yaml
sed -i 's/:organizations_enabled: false/:organizations_enabled: true/' config/settings.yaml
echo "gemspec :path => '../katello', :development_group => :katello_dev" >> bundler.d/Gemfile.local.rb
echo "gem 'psych'" >> bundler.d/Gemfile.local.rb

bundle install --without mysql:mysql2:development

npm install
npm install --no-optional --global-style true
npm install phantomjs
./node_modules/webpack/bin/webpack.js --bail --config config/webpack.config.js
bundle exec rake db:create --trace
bundle exec rake db:migrate --trace
bundle exec rake jenkins:katello TESTOPTS="-v" --trace
