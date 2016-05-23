require 'fileutils'
require 'pathname'
require 'tmpdir'

app_name = "Alfred 3"
version = '652'
url = 'https://cachefly.alfredapp.com/Alfred_3.0_652.zip'
sha256 = '01f0c1d83eeff378af071f446a9782320ab20503b588a0aff4a2daba5de12d45'

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
