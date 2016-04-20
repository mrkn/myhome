#! /bin/bash

sudo xcode-select --install
sudo xcodebuild -license
sudo gem update --system
sudo gem install bundler -n /usr/local/bin
sudo gem install homesick -n /usr/local/bin
bundle install --path=vendor/bundle
