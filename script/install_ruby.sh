#! /bin/bash

ruby_version=$1

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
  gem-src \
  bundler \
  byebug \
  homesick \
  middleman \
  padrino \
  pry \
  rails \
  sinatra \
  brewdler
rbenv rehash
