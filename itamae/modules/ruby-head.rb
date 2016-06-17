version = '2.4.0-dev'

include_recipe 'gdbm'
include_recipe 'git'
include_recipe 'gmp'
include_recipe 'libyaml'
include_recipe 'openssl'
include_recipe 'qdbm'
include_recipe 'readline'
include_recipe 'rbenv'

brew_prefix = `brew --prefix`.chomp
gdbm_dir = `brew --prefix gdbm`.chomp
gmp_dir = `brew --prefix gmp`.chomp
libyaml_dir = `brew --prefix libyaml`.chomp
openssl_dir = `brew --prefix openssl`.chomp
qdbm_dir = `brew --prefix qdbm`.chomp
readline_dir = `brew --prefix readline`.chomp

configure_opts = [
  %w[
    --enable-shared
    --disable-install-doc
    --with-out-ext=tk,tk/*
    --with-dbm-type=qdbm
  ],
  "--with-opt-dir=#{brew_prefix}",
  "--with-gmp-dir=#{gmp_dir}",
  "--with-libyaml-dir=#{libyaml_dir}",
  "--with-openssl-dir=#{openssl_dir}",
  "--with-dbm-dir=#{qdbm_dir}",
  "--with-readline-dir=#{readline_dir}",
].join(' ')

optflags = "-O0 -mtune=native -march=native"
debugflags = "-g3 -gdwarf-4"
verbose = '-v' if Itamae.logger.level == ::Logger::DEBUG

execute "rbenv uninstall -f #{version} || :"

execute "rm -rf ~/.rbenv/sources/#{version} || :"

execute "rbenv install #{version}" do
  command <<-CMD
    eval "$(rbenv init -)";
    CONFIGURE_OPTS='#{configure_opts}' optflags='#{optflags}' debugflags='#{debugflags}' RUBY_CFLAGS='${optflags} ${debugflags} ${warnflags}' rbenv install -k #{verbose} #{version} &&
      RBENV_VERSION='#{version}' gem update --system &&
      RBENV_VERSION='#{version}' gem install bundler itamae
  CMD

  not_if <<-CMD unless version.end_with?('-dev')
    eval "$(rbenv init -)";
    rbenv versions | grep '#{version}'
  CMD
end
