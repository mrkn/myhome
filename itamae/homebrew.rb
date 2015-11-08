brew_prefix = File.expand_path('~/.brew')
brew_url = 'https://github.com/Homebrew/homebrew/tarball/master'

directory brew_prefix do
  mode "755"
end

execute "Download and extract homebrew into #{brew_prefix}" do
  command "curl -L #{brew_url} | tar xz --strip 1 -C #{brew_prefix}"
  not_if %[test -x #{brew_prefix}/bin/brew]
end

execute "brew tap homebrew/bundle" do
  command "PATH=~/.brew/bin:$PATH brew tap homebrew/bundle"
  not_if %[brew tap | grep homebrew/bundle]
end

execute "brew update" do
  command "PATH=~/.brew/bin:$PATH brew update"
end
