require 'fileutils'
require 'pathname'
require 'tmpdir'

app_name = 'GPGTools'
version = '2015.09'
sha256 = '0ec0f4bb66ef660d3c3b0433dd3186e093a1b4f23bf8fac8b4ebca9fa6d80420'
url = "https://releases.gpgtools.org/GPG_Suite-#{version}.dmg"

pkg_file = 'Install.pkg'
uninstall_app = 'Uninstall.app'

tmpdir = Dir.mktmpdir
at_exit do
  FileUtils.remove_entry_secure(tmpdir)
end

mountpoint = Pathname(tmpdir).join('vol')
mountpoint.mkpath

execute "Download #{app_name}" do
  command "curl -L -O #{url}"
  cwd tmpdir
end

execute "Uninstall existing #{app_name}" do
  command <<-CMD
    hdiutil attach #{File.basename(url)} -readonly -mountpoint #{mountpoint} &&
      open -W #{mountpoint.join(uninstall_app)}";
    exitcode=$?;
    hdiutil detach #{mountpoint} || :;
    exit $exitcode
  CMD

  cwd tmpdir
  only_if "test -f #{File.basename(url)}"
end

execute "Install #{app_name}" do
  command <<-CMD
    hdiutil attach #{File.basename(url)} -readonly -mountpoint #{mountpoint} &&
      sudo installer -pkg #{mountpoint.join(pkg_file)} -target /;
    exitcode=$?;
    hdiutil detach #{mountpoint} || :;
    exit $exitcode
  CMD

  cwd tmpdir
  only_if "test -f #{File.basename(url)}"
end
