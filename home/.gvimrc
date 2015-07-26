set background dark
set imdisable

if has("gui_running")
  if has("gui_macvim")
    set guifont=Ricty:h14,Menlo:h12,Osaka-Mono:h14
    set linespace=1
  endif
endif

source ~/.vimrc
