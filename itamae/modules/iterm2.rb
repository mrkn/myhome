require 'tmpdir'
require 'fileutils'

version = '2.1.4'
sha256 = '1062b83e7808dc1e13362f4a83ef770e1c24ea4ae090d1346b49f6196e9064cd'
url = "https://iterm2.com/downloads/stable/iTerm2-#{version.gsub('.', '_')}.zip"

tmpdir = Dir.mktmpdir
at_exit do
  FileUtils.remove_entry_secure(tmpdir)
end

execute "Download iTerm 2" do
  command "curl -L -O #{url}"
  cwd tmpdir
end

execute "Uninstall existing iTerm 2" do
  command "rm -rf /Applications/iTerm.app"
  only_if "test -d /Applications/iTerm.app"
end

execute "Install iTerm 2" do
  command "unzip -x -d /Applications #{File.basename(url)}"
  cwd tmpdir
end
