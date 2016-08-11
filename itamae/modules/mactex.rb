require 'fileutils'
require 'pathname'
require 'tmpdir'

# References:
# - https://snap.textfile.org/20151006085255/
# - http://qiita.com/hideaki_polisci/items/3afd204449c6cdd995c9
# - http://doratex.hatenablog.jp/entry/20160608/1465311609

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

app_name = 'MacTeX'
release_year = 2016
sha256 = '34e5c48846a674e0025e92bf1ab7bb43a1108f729b4c26c61edcda24fa5383e3'
url = 'http://tug.org/cgi-bin/mactex-download/MacTeX.pkg'

download_filename = 'mactex-20160603.pkg'
pkg_file = download_filename
texlive_root = Pathname("/usr/local/texlive/#{release_year}")

install_tl = texlive_root.join("install-tl")
need_to_install = true
if File.executable? install_tl
  installed_release_year = (`#{install_tl} --version`[/version (\d+)/, 1] || 0).to_i
  need_to_install &&= release_year > installed_release_year
end

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

execute "Install #{app_name}" do
  command <<-CMD
    sudo installer -pkg '#{pkg_file}' -target /
  CMD

  cwd tmpdir
  only_if "#{need_to_install} && test -f #{download_filename}"
end

# Prepare path just in case
ENV['PATH'] = [
  texlive_root.join("bin/x86_64-darwin"),
  ENV['PATH']
].join(':')

execute "sudo tlmgr update --self --all"

execute "tlmgr info jfontmaps"

execute "prepare japanese fonts" do
  command <<-CMD
    sudo perl cjk-gs-integrate.pl --link-texmf --force && \
      sudo mktexlsr && \
      sudo updmap-sys --setoption kanjiEmbed hiragino-elcapitan-pron
  CMD
  cwd texlive_root.join("texmf-dist/scripts/cjk-gs-integrate").to_s
end
