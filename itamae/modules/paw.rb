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

app_name = 'Paw'
version = '3.0.8'
sha256 = '16f5dc4b5883a01488ac72c01a5da3c23a3548fb5fe7f40ea3e87bb8312e35ab'
url = 'https://paw.cloud/download'

download_filename = 'Paw-3.0.8-3000008000.zip'
app_path = Pathname("/Applications/#{app_name}.app")
info_plist = app_path.join("Contents/Info.plist")

if File.file?(info_plist)
  existing_version = `defaults read '#{info_plist}' CFBundleShortVersionString`
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
