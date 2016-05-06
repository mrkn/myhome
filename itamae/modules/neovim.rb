package 'neovim/neovim/neovim' do
  options '--env=std'
end

include_recipe 'python'

execute 'pip install neovim' do
  command %[eval "$(pyenv init -)"; pip install neovim]
end
