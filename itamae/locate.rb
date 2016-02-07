execute "launchctl load -w com.apple.locate.plist" do
  command "sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist"
  not_if "sudo launchctl list com.apple.locate 2>&1 >/dev/null"
end
