local o = vim.o
local wo = vim.wo
local bo = vim.bo

o.backspace = "indent,eol,start"
o.fileencodings = "utf-8,latin"
o.title = true
o.backup = false
o.hlsearch = true
o.showcmd = true
o.cmdheight = 1
o.laststatus = 2
o.scrolloff = 10
o.shell = "zsh"
o.inccommand = "split"
o.sc = false
o.ru = false
o.sm = false
o.smarttab = true
o.termguicolors = true

wo.number = true
wo.wrap = false
wo.cursorline = true

bo.autoindent = true
bo.expandtab = true
bo.shiftwidth = 2
bo.tabstop = 2
bo.ai = true
bo.si = true

--set t_BE=
--filetype plugin indent on
--set path+=**
--set wildignore+=*/node_modules/*
--autocmd InsertLeave * set nopaste


--colorscheme onehalfdark
--let g:transparent_enabled = v:true

local cmd = vim.cmd
local u = require('utils')

cmd('au InsertLeave * set nopaste')

u.create_augroup({
    { 'WinEnter', '*', 'set', 'cul' },
    { 'WinLeave', '*', 'set', 'nocul' },
}, 'BgHighlight')




