include_recipe './python.rb'

execute 'pip install -U jupyter' do
  command %[eval "$(pyenv init -)"; pyenv exec pip install -U jupyter]
end
