require 'fileutils'
require 'pathname'
require 'tmpdir'

def check_sha256(path, expected, bufsize=1024)
  require 'digest/sha2'
  digest = Digest::SHA256.new
  open(path, 'rb:ASCII-8BIT') do |f|
    until f.eof?
      digest << f.read(bufsize)
    end
  end
  actual = digest.hexdigest
  actual == expected
end

app_name = 'Dash'
version = '3.4.1'
sha256 = '6f43e7cfcc21497c23469c6db32da0d2bf34de6692b8a3f3fad976dce7c39c1a'
url = 'https://tokyo.kapeli.com/downloads/v3/Dash.zip'
download_filename = File.basename(url)

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

# copy file already exist in Downloads directory
if need_to_install
  downloaded_path = Pathname('~/Downloads').expand_path.join(download_filename)
  if downloaded_path.file? && check_sha256(downloaded_path, sha256)
    FileUtils.copy(downloaded_path, tmpdir)
  end
end

execute "Download #{app_name}" do
  command "curl -L -O #{url}"
  cwd tmpdir
  not_if "#{!need_to_install} || test -f #{download_filename}"
end

execute "Uninstall existing #{app_name}" do
  command "rm -rf '#{app_path}'"
  only_if "#{need_to_install} && test -d '#{app_path}'"
end

execute "Install #{app_name}" do
  command "unzip -x -d /Applications '#{download_filename}'"
  cwd tmpdir
  only_if "#{need_to_install} && test -f '#{download_filename}'"
end
