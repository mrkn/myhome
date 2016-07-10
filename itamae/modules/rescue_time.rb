require 'fileutils'
require 'pathname'
require 'tmpdir'

app_name = 'RescueTime'
version = '2.10.9.2450'
sha256 = '11b14fc3e3f7668cb04d5b9248d62dd9e14dce00361aae53af9e4b6ac1331a6e'
url = 'https://www.rescuetime.com/installers/RescueTimeInstaller.dmg'
download_filename = File.basename(url)

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
