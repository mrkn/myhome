require 'fileutils'
require 'pathname'
require 'tmpdir'

version = '1.5.4.9'
sha256 = 'ee6334cb41f2d0a3d164b5c1de61d40f70d4cd9c829a35beba437ba9f6919d55'
url = 'http://www.duetdisplay.com/mac/'
archive_name = 'duet.zip'

app_path = Pathname("/Applications/duet.app")
info_plist = app_path.join("Contents/Info.plist")

if File.file?(info_plist)
  existing_version = `defaults read #{info_plist} CFBundleVersion`
end

need_to_install = existing_version.nil? || (version > existing_version)

tmpdir = Dir.mktmpdir
at_exit do
  FileUtils.remove_entry_secure(tmpdir)
end

execute "Download #{url}" do
  command "curl -L -o #{archive_name} #{url}"
  cwd tmpdir
  only_if "#{need_to_install}"
end

execute "Uninstall existing #{app_path.basename}" do
  command "rm -rf #{app_path}"
  only_if "#{need_to_install} && test -d #{app_path}"
end

execute "Install #{app_path.basename}" do
  command "unzip -x #{archive_name} && open -W #{app_path.basename}"
  cwd tmpdir
  only_if "#{need_to_install} && test -f #{archive_name}"
end
