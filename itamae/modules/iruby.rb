include_recipe "./jupyter"
include_recipe "./ruby"
include_recipe "./rbczmq"

execute "gem install iruby" do
  command %[eval "$(rbenv init -); gem install iruby"]
end

execute "iruby register" do
  command %[eval "$(rbenv init -); iruby register --force"]
end
