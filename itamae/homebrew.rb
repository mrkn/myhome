brew_prefix = File.expand_path('~/.brew')
brew_url = 'https://github.com/Homebrew/homebrew/tarball/master'

directory brew_prefix do
  mode "755"
end

execute "Download and extract homebrew into #{brew_prefix}" do
  command "curl -L #{brew_url} | tar xz --strip 1 -C #{brew_prefix}"
end
