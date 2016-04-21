require 'fileutils'
require 'pathname'
require 'tmpdir'

app_name = 'Postico'
version = '1.0.6'
sha256 = '55220eb7ce26232b8fac25f963d870ef3025a8aa57fee71a47a8f5c0141876e0'
url = "https://s3-eu-west-1.amazonaws.com/eggerapps-downloads/postico-#{version}.zip"
download_filename = File.basename(url)

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
  command "unzip -x -d /Applications '#{download_filename}'"
  cwd tmpdir
  only_if "#{need_to_install} && test -f '#{download_filename}'"
end
