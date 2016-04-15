require 'fileutils'
require 'pathname'
require 'tmpdir'
require 'uri'

app_name = 'Visual Studio Code'
version = '1.0.0'
sha256 = '78b698bbc3968d64e30e056481ef32994f8aa66c934a62065dddbfed240d641a'
url = 'https://go.microsoft.com/fwlink/?LinkID=620882'
archive_name = 'VSCode-darwin-stable.zip'

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

execute "Download #{app_name}" do
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
