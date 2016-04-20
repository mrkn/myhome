require 'fileutils'
require 'pathname'
require 'tmpdir'

app_name = 'Dropbox'
version = '3.18.1'
sha256 = '9d4a43362710c6d3c6a94040fb44d6845fa3bf37a721c2b61356e52b89409254'
url = 'https://www.dropbox.com/download?plat=mac'
download_filename = 'DropboxInstaller.dmg'

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

execute "download #{app_name}" do
  command "curl -L -o '#{download_filename}' '#{url}'"
  cwd tmpdir
  only_if "#{need_to_install}"
end

#execute "Uninstall existing #{app_name}" do
#  command "rm -rf #{app_path}"
#  only_if "#{need_to_install} && test -d #{app_path}"
#end

execute "Install #{app_name}" do
  command <<-CMD
    hdiutil attach #{download_filename} -readonly -mountpoint #{mountpoint} &&
      open -W #{mountpoint.join(app_path.basename)};
    exitcode=$?;
    hdiutil detach #{mountpoint} || :;
    exit $exitcode
  CMD

  cwd tmpdir
  only_if "#{need_to_install} && test -f #{download_filename}"
end
