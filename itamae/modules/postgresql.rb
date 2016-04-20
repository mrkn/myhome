require 'pathname'

package 'postgresql'

launch_agents_dir = Pathname('~/Library/LaunchAgents').expand_path

directory launch_agents_dir.to_s do
  mode '755'
end

postgresql_dir = Bundler.with_clean_env do
  Pathname(`brew --prefix postgresql`.chomp)
end

Dir[postgresql_dir.join('*.plist')].each do |plist|
  link launch_agents_dir.join(File.basename(plist)).to_s do
    to plist.to_s
  end
end

execute "launchctl load #{launch_agents_dir.join('homebrew.mxcl.postgresql.plist')}" do
  not_if 'launchctl list homebrew.mxcl.postgresql.plist >&/dev/null'
end
