require 'fileutils'
require 'pathname'
require 'tmpdir'

app_name = "iTerm"
version = '2.1.4'
sha256 = '1062b83e7808dc1e13362f4a83ef770e1c24ea4ae090d1346b49f6196e9064cd'
url = "https://iterm2.com/downloads/stable/iTerm2-#{version.gsub('.', '_')}.zip"
archive_name = File.basename(url)

app_path = Pathname("/Applications/#{app_name}.app")
info_plist = app_path.join("Contents/Info.plist")

if File.file?(info_plist)
  existing_version = `defaults read '#{info_plist}' CFBundleVersion`
end

need_to_install = existing_version.nil? || (version > existing_version)

tmpdir = Dir.mktmpdir
at_exit do
  FileUtils.remove_entry_secure(tmpdir)
end

execute "Download iTerm 2" do
  command "curl -L -O '#{url}'"
  cwd tmpdir
  only_if "#{need_to_install}"
end

execute "Uninstall existing #{app_name}" do
  command "rm -rf '#{app_path}'"
  only_if "#{need_to_install} && test -d '#{app_path}'"
end

execute "Install #{app_name}" do
  command "unzip -x -d /Applications '#{archive_name}'"
  cwd tmpdir
  only_if "#{need_to_install} && test -f '#{archive_name}'"
end
