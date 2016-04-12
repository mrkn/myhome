require 'fileutils'
require 'pathname'
require 'tmpdir'

app_name = 'MySQLWorkbench'
version = '6.3.6.CE'
sha256 = '81732bddff9e9d6b71cc565e4d3b4636e0e47db5b344aaef4b7e20c83177d94a'
url = "http://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-6.3.6-osx-x86_64.dmg"

app_path = Pathname("/Applications/#{app_name}.app")
info_plist = app_path.join("Contents/Info.plist")

if File.file?(info_plist)
  existing_version = `defaults read #{info_plist} CFBundleShortVersionString`
end

need_to_install = existing_version.nil? || (version > existing_version)

tmpdir = Dir.mktmpdir
at_exit do
  FileUtils.remove_entry_secure(tmpdir)
end

mountpoint = Pathname(tmpdir).join('vol')
mountpoint.mkpath

execute "Download #{app_name}" do
  command "curl -L -O #{url}"
  cwd tmpdir
  only_if "#{need_to_install}"
end

execute "Uninstall existing #{app_name}" do
  command "rm -rf #{app_path}"
  only_if "#{need_to_install} && test -d #{app_path}"
end

execute "Install #{app_name}" do
  command <<-CMD
    hdiutil attach #{File.basename(url)} -readonly -mountpoint #{mountpoint} &&
      cp -r #{mountpoint.join(app_path.basename)} #{app_path.parent};
    exitcode=$?;
    hdiutil detach #{mountpoint} || :;
    exit $exitcode
  CMD

  cwd tmpdir
  only_if "#{need_to_install} && test -f #{File.basename(url)}"
end
