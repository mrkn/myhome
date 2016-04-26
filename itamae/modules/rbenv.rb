include_recipe 'brew_update'

package 'rbenv'
execute 'brew upgrade --cleanup rbenv || :'

package 'rbenv-aliases'
execute 'brew upgrade --cleanup rbenv-aliases || :'

execute 'brew uninstall ruby-build' do
  only_if 'brew --prefix ruby-build'
end

execute 'git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build' do
  not_if 'test -d ~/.rbenv/plugins/ruby-build/.git'
end

execute 'cd ~/.rbenv/plugins/ruby-build && git pull --rebase' do
  only_if 'test -d ~/.rbenv/plugins/ruby-build/.git'
end
