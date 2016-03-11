require 'fileutils'
require 'pathname'
require 'tmpdir'

version = '2.1.4'
sha256 = '1062b83e7808dc1e13362f4a83ef770e1c24ea4ae090d1346b49f6196e9064cd'
url = "https://iterm2.com/downloads/stable/iTerm2-#{version.gsub('.', '_')}.zip"

app_path = Pathname("/Applications/iTerm.app")
info_plist = app_path.join("Contents/Info.plist")

if File.file?(info_plist)
  existing_version = `defaults read #{info_plist} CFBundleVersion`
end

need_to_install = existing_version.nil? || (version > existing_version)

tmpdir = Dir.mktmpdir
at_exit do
  FileUtils.remove_entry_secure(tmpdir)
end

execute "Download iTerm 2" do
  command "curl -L -O #{url}"
  cwd tmpdir
  only_if "#{need_to_install}"
end

execute "Uninstall existing iTerm 2" do
  command "rm -rf /Applications/iTerm.app"
  only_if "#{need_to_install} && test -d /Applications/iTerm.app"
end

execute "Install iTerm 2" do
  command "unzip -x -d /Applications #{File.basename(url)}"
  cwd tmpdir
  only_if "#{need_to_install} && test -f #{File.basename(url)}"
end
