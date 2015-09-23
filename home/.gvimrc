set background dark
set imdisable

if has("gui_running")
  if has("gui_macvim")
    set guifont=Ricty:h18,Menlo:h16
    set linespace=6
  endif
endif

source ~/.vimrc
