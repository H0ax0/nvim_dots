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
o.mouse = "nv"

wo.number = true
wo.wrap = false
wo.cursorline = true

bo.autoindent = true
bo.expandtab = true
bo.shiftwidth = 2
bo.tabstop = 2
bo.ai = true
bo.si = true

--o.path:append "**"
--o.wildignore:append "*/node_modules/*"
