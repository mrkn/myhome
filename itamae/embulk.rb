embulk_latest_url = 'http://dl.embulk.org/embulk-latest.jar'
destination = File.expand_path('~/.embulk/bin/embulk')

execute "Download embulk-latest.jar and deploy it as #{destination}" do
  command <<-CMD
    curl --create-dirs -o "#{destination}" -L "#{embulk_latest_url}" &&
    chmod +x "#{destination}"
  CMD

  not_if %[test -x "#{destination}"]
end
