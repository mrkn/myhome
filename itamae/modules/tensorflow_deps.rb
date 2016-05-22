include_recipe './bazel.rb'
include_recipe './swig.rb'
include_recipe './python.rb'

execute "pip install -U six" do
  command %[eval "$(pyenv init -)"; pyenv exec pip install -U six]
end

execute "pip install -U numpy" do
  command %[eval "$(pyenv init -)"; pyenv exec pip install -U numpy]
end

execute "pip install wheel" do
  command %[eval "$(pyenv init -)"; pyenv exec pip install wheel]
end

execute "pip install jupyter" do
  command %[eval "$(pyenv init -)"; pyenv exec pip install -U jupyter]
end
