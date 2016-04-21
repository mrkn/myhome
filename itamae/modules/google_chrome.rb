require 'fileutils'
require 'pathname'
require 'tmpdir'

app_name = 'Google Chrome'
version = '2623.112'
sha256 = '69c416f9ee5cb60ffd91baad3db567cbc98da9f58cb5348f0ef927820a6020c9'
url = 'https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg'
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

mountpoint = Pathname(tmpdir).join('vol')
mountpoint.mkpath

execute "Download #{app_name}" do
  command "curl -L -O '#{url}'"
  cwd tmpdir
  only_if "#{need_to_install}"
end

execute "Uninstall existing #{app_name}" do
  command "rm -rf #{app_path}"
  only_if "#{need_to_install} && test -d '#{app_path}'"
end

execute "Install #{app_name}" do
  command <<-CMD
    hdiutil attach '#{download_filename}' -readonly -mountpoint '#{mountpoint}'&&
      cp -r '#{mountpoint.join(app_path.basename)}' '#{app_path.parent}';
    exitcode=$?;
    hdiutil detach '#{mountpoint}' || :;
    exit $exitcode
  CMD

  cwd tmpdir
  only_if "#{need_to_install} && test -f '#{download_filename}'"
end
