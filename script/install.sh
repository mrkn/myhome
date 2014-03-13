#! /bin/bash

# Variables
ruby_version=2.1.1

# Check Xcode CLI tools
clang --version >/dev/null 2>&1

# Install homebrew
ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"

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
  git clone git@github.com:sstephenson/ruby-build.git ~/.rbenv
}

# Load rbenv
export PATH=~/.rbenv/bin:$PATH
eval "$(rbenv init -)"

# Install ruby
RUBY_CONFIGURE_OPTS='
  --enable-shared
  --enable-pthread
  --disable-install-doc
  --with-arch=x86_64
  --with-dbm-dir=/usr/local/opt/berkeley-db --with-dbm-type=db5
  --with-gdbm-dir=/usr/local/opt/gdbm
  --with-libffi-dir=/usr/local/opt/libffi
  --with-libyaml-dir=/usr/local/opt/libyaml
  --with-openssl-dir=/usr/local/opt/openssl
  --with-readline-dir=/usr/local/opt/readline --disable-libedit
  --with-valgrind
  --with-out-ext=tk,tk/*
  --with-opt-dir=/usr/local
  CC=clang CXX=clang++
'
MAKE_OPTS='-j 8'
[ -d ~/.rbenv/versions/${ruby_version} ] && rm -rf ~/.rbenv/versions/${ruby_version}
rbenv install -k ${ruby_version}
pushd ~/.rbenv/sources/${ruby_version}/ruby-${ruby_version}
make clean
make ${MAKE_OPTS} \
  optflags="-O3 -march=corei7-avx -mtune=corei7-avx" \
  debugflags="-ggdb3"
make install
popd
rbenv global ${ruby_version}
rbenv rehash

# Updating gem
gem update --system
rbenv rehash

# Install gems
gem install \
  bundler \
  byebug \
  homesick \
  middleman \
  padrino \
  pry \
  rails \
  sinatra
rbenv rehash

# Homesick
homesick clone mrkn/myhome
homesick symlink myhome

# brew bundle
brew bundle
