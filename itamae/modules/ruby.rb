include_recipe 'gdbm'
include_recipe 'git'
include_recipe 'gmp'
include_recipe 'libyaml'
include_recipe 'openssl'
include_recipe 'qdbm'
include_recipe 'readline'

ruby_versions = %w[
  2.1.10
  2.2.4
  2.3.0
  2.4.0-dev
]

ruby_global_version = '2.3.0'

package 'rbenv'
package 'rbenv-aliases'

package 'ruby-build' do
  options '--HEAD'
end

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

[*ruby_versions, ruby_global_version].uniq.each do |version|
  execute "rbenv install #{version}" do
    command <<-CMD
      eval "$(rbenv init -)";
      CONFIGURE_OPTS='#{configure_opts}' rbenv install #{version} &&
        RBENV_VERSION='#{version}' gem update --system &&
        RBENV_VERSION='#{version}' gem install bundler itamae
    CMD

    not_if <<-CMD
      eval "$(rbenv init -)";
      rbenv versions | grep '#{version}'
    CMD
  end
end

execute "rbenv global #{ruby_global_version}" do
  command %[eval "$(rbenv init -)"; rbenv global '#{ruby_global_version}']
  not_if  %[eval "$(rbenv init -)"; rbenv versions | grep '* #{ruby_global_version}']
end
