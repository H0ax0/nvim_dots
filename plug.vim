if has("nvim")
  let g:plug_home = stdpath('data') . '/plugged'
endif

call plug#begin()

Plug 'sonph/onehalf', { 'rtp': 'vim' }

if has("nvim")
  Plug 'neoclide/coc.nvim', {'branch' : 'release'}
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'kristijanhusak/defx-git'
  Plug 'kristijanhusak/defx-icons'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'windwp/nvim-autopairs'
  Plug 'preservim/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'ryanoasis/vim-devicons'
  Plug 'xiyaowong/nvim-transparent'
  Plug 'towolf/vim-helm'
endif

call plug#end()
