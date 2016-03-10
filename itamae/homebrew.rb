require 'etc'

brew_prefix = File.expand_path('/opt/brew')
brew_url = 'https://github.com/Homebrew/homebrew/tarball/master'

def get_user_and_group()
  if (login = Etc.getlogin)
    pw = Etc.getpwnam(login)
  else
    pw = Etc.getpwuid
  end
  user_name = pw.name
  gr = Etc.getgrgid(pw.gid)
  group_name = gr.name
  [user_name, group_name]
end

user_name, group_name = get_user_and_group()
execute "mkdir #{brew_prefix}" do
  command "sudo sh -c 'mkdir -p #{brew_prefix}; chown #{user_name}:#{group_name} #{brew_prefix}'"
  not_if %[test -d #{brew_prefix} -a -w #{brew_prefix}]
end

execute "Download and extract homebrew into #{brew_prefix}" do
  command "curl -L #{brew_url} | tar xz --strip 1 -C #{brew_prefix}"
  not_if %[test -x #{brew_prefix}/bin/brew]
end

execute "brew tap homebrew/bundle" do
  command "env PATH=#{brew_prefix}/bin:$PATH brew tap homebrew/bundle"
  not_if %[env PATH=#{brew_prefix}/bin:$PATH brew tap | grep homebrew/bundle]
end

execute "brew update" do
  command "env PATH=#{brew_prefix}/bin:$PATH brew update"
end
