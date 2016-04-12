require 'fileutils'
require 'pathname'
require 'tmpdir'

app_name = 'ShareMouse'
version = '3.0.41'
sha256 = '52fdbb34f1c15864d00a6decea24e00d1d70dd7707bd11034f5b95215490130a'
url = "http://www.keyboard-and-mouse-sharing.com/ShareMouseSetup.dmg"

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

