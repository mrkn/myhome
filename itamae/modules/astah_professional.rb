require 'fileutils'
require 'pathname'
require 'tmpdir'

app_name = 'astah professional'
version = '7.0.0'
sha256 = 'f9077dfe61f7ccf378c68031f9d888f2c5d349a83aeb34c9517cc046baca953e'
url = "http://members.change-vision.com/files/_nPtmcdYCoVyaTyqExWSZIw8YGIJGgwt6/astah_professional/7_0_0/astah-professional-7_0_0-846701-MacOs.dmg"

pkg_file = 'astah professional ver 7_0_0.pkg'

app_path = Pathname("/Applications/astah professional/#{app_name}.app")
uninstall_path = app_path.parent
info_plist = app_path.join("Contents/Info.plist")

if File.file?(info_plist)
  existing_version = `defaults read '#{info_plist}' CFBundleVersion`.chomp
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
  command "rm -rf '#{uninstall_path}'"
  only_if "#{need_to_install} && test -d '#{uninstall_path}'"
end

execute "Install #{app_name}" do
  command <<-CMD
    hdiutil attach #{File.basename(url)} -readonly -mountpoint #{mountpoint} &&
      sudo installer -pkg '#{mountpoint.join(pkg_file)}' -target /;
    exitcode=$?;
    hdiutil detach #{mountpoint} || :;
    exit $exitcode
  CMD

  cwd tmpdir
  only_if "#{need_to_install} && test -f #{File.basename(url)}"
end
