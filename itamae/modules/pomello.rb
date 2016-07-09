require 'fileutils'
require 'pathname'
require 'tmpdir'

app_name = 'Pomello'
version = '0.7.2'
sha256 = 'b1991dd5c307b7274f0d22e2b7e8b147e63f5a9b2a99055b11c21e44ae13b46b<Paste>'
url = "https://pomelloapp.com/download/mac"
download_filename = "#{app_name}-#{version}.dmg"

app_path = Pathname("/Applications/#{app_name}.app")
info_plist = app_path.join("Contents/Info.plist")

if File.file?(info_plist)
  existing_version = `defaults read #{info_plist} CFBundleVersion`
end

need_to_install = existing_version.nil? || (version > existing_version)

tmpdir = Dir.mktmpdir
at_exit do
  FileUtils.remove_entry_secure(tmpdir)
end

mountpoint = Pathname(tmpdir).join('vol')
mountpoint.mkpath

execute "Download #{app_name}" do
  command "curl -L -o '#{download_filename}' '#{url}'"
  cwd tmpdir
  only_if "#{need_to_install}"
end

execute "Uninstall existing #{app_name}" do
  command "rm -rf #{app_path}"
  only_if "#{need_to_install} && test -d #{app_path}"
end

execute "Install #{app_name}" do
  command <<-CMD
    hdiutil attach '#{download_filename}' -readonly -mountpoint '#{mountpoint}' &&
      cp -r '#{mountpoint.join(app_path.basename)}' '#{app_path.parent}';
    exitcode=$?;
    hdiutil detach '#{mountpoint}' || :;
    exit $exitcode
  CMD

  cwd tmpdir
  only_if "#{need_to_install} && test -f '#{download_filename}'"
end
