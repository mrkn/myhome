version = '2.4.0-dev'

include_recipe 'autoconf'
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

rbenv_root = File.expand_path('~/.rbenv')
rbenv_sources_version_dir = File.expand_path("~/.rbenv/sources/#{version}")
clone_dest = 'ruby-head'
src_dir = File.join(rbenv_sources_version_dir, clone_dest)

ruby_prefix_dir = File.expand_path("~/.rbenv/versions/#{version}")

optflags = "-O0 -mtune=native -march=native"
debugflags = "-g3 -gdwarf-4"

execute "rbenv uninstall -f #{version} || :"

directory rbenv_sources_version_dir

execute "git clone git@github.com:ruby/ruby.git #{clone_dest}" do
  cwd rbenv_sources_version_dir
  not_if "test -d #{clone_dest}"
end

execute "git pull --rebase" do
  cwd src_dir
end

execute "autoreconf" do
  cwd src_dir
end

execute "configure" do
  command <<-CMD
    ./configure \
      --prefix=#{ruby_prefix_dir} \
      --enable-shared \
      --disable-install-doc \
      --with-out-ext=tk,tk/* \
      --with-dbm-type=qdbm \
      --with-opt-dir=#{brew_prefix} \
      --with-gmp-dir=#{gmp_dir} \
      --with-libyaml-dir=#{libyaml_dir} \
      --with-openssl-dir=#{openssl_dir} \
      --with-dbm-dir=#{qdbm_dir} \
      --with-readline-dir=#{readline_dir} \
      optflags="#{optflags}" \
      debugflags="#{debugflags}"
  CMD
  cwd src_dir
end

execute "make" do
  command <<-CMD
    make -j 8
  CMD
  cwd src_dir
end

execute "make install" do
  command <<-CMD
    make install
  CMD
  cwd src_dir
end

execute "gem update --system" do
  command %Q[eval "$(rbenv init -); RBENV_VERSION='#{version}' gem update --no-document --system"]
end

execute "gem update --system" do
  command %Q[eval "$(rbenv init -); RBENV_VERSION='#{version}' gem install --no-document bundler itamae"]
end
