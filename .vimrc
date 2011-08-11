autocmd!
syntax on
set background=dark
set showmatch
set showtabline=2
set nu
set nuw=4
set cursorline
set nowrap
set modifiable
set encoding=utf-8
set ff=unix
set nobomb
set wildmenu
set cmdheight=2
set expandtab
set shiftwidth=4
set softtabstop=4
set smarttab
set autoindent
set smartindent
set textwidth=120
set list lcs=tab:>-,trail:-,extends:>

if &t_Co > 255
    colo xoria256
else
    colo torte
endif

cmap w!! w !sudo tee %
