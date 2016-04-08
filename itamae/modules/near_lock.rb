require 'fileutils'
require 'pathname'
require 'tmpdir'

app_name = 'Near Lock'
version = '3.5.1'
sha256 = 'd65459f0f06f094e9ac83c1aafb2b774889e6485174e56b3a73a34ea8875a810'
url = "http://nearlock.me/downloads/nearlock.dmg"

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
  command "rm -rf '#{app_path}'"
  only_if "#{need_to_install} && test -d '#{app_path}'"
end

execute "Install #{app_name}" do
  command <<-CMD
    hdiutil attach '#{File.basename(url)}' -readonly -mountpoint '#{mountpoint}' &&
      cp -r '#{mountpoint.join(app_path.basename)}' '#{app_path.parent}';
    exitcode=$?;
    hdiutil detach '#{mountpoint}' || :;
    exit $exitcode
  CMD

  cwd tmpdir
  only_if "#{need_to_install} && test -f '#{File.basename(url)}'"
end
