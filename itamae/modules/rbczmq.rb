include_recipe "./ruby"
include_recipe "./zeromq"

execute "gem install rbczmq" do
  command %[eval "$(rbenv init -); gem install rbczmq"]
end
