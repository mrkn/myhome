#! /bin/bash

# Variables
ruby_version=2.2.0
install_ruby=$(dirname $0)/install_ruby.sh

# Check Xcode CLI tools
clang --version >/dev/null 2>&1

# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install bootstrap packages
brew install berkeley-db
brew install gdbm
brew install gmp
brew install libffi
brew install libyaml
brew install openssl
brew install readline
brew install valgrind

# Install rbenv
[ -d ~/.rbenv ] || {
  git clone git@github.com:sstephenson/rbenv.git ~/.rbenv
}

# Install ruby-build
[ -d ~/.rbenv/plugins/ruby-build ] || {
  git clone git@github.com:sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
}

# Load rbenv
export PATH=~/.rbenv/bin:$PATH
eval "$(rbenv init -)"

# Install ruby
/bin/bash ${install_ruby} ${ruby_version}

# Homesick
homesick clone mrkn/myhome
homesick symlink myhome

# Brewdler
brewdle install
