require 'fileutils'
require 'pathname'
require 'tmpdir'

app_name = 'DTerm'
cf_bundle_version = '5201'
sha256 = '34292f3450567f2964288998b3fdda0f85f49a36845457c46a74974e41c234ac'
url = "http://files.decimus.net/DTerm/#{app_name}.zip"

app_basename = "#{app_name}.app"
app_path = Pathname("/Applications/#{app_basename}")
info_plist = app_path.join("Contents/Info.plist")

if File.file?(info_plist)
  existing_version = `defaults read #{info_plist} CFBundleVersion`
end

need_to_install = existing_version.nil? || (cf_bundle_version > existing_version)

tmpdir = Dir.mktmpdir
at_exit do
  FileUtils.remove_entry_secure(tmpdir)
end

execute "Download #{app_name}" do
  command "curl -L -O #{url}"
  cwd tmpdir
  only_if "#{need_to_install}"
end

execute "Uninstall existing #{app_name}" do
  command "rm -rf #{app_path}"
  only_if "#{need_to_install} && test -d #{app_path} -o -L #{app_path}"
end

execute "Install iTerm 2" do
  command "unzip -x -d #{app_path.parent} #{File.basename(url)}"
  cwd tmpdir
  only_if "#{need_to_install} && test -f #{File.basename(url)}"
end

