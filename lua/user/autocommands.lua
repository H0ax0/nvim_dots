vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "qf", "help", "man", "lspinfo", "spectre_panel", "lir" },
	callback = function()
		vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR> 
      set nobuflisted 
    ]])
	end,
})

-- Remove statusline and tabline when in Alpha
vim.api.nvim_create_autocmd({ "User" }, {
	pattern = { "AlphaReady" },
	callback = function()
		vim.cmd([[
   	   set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2  
      set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3
    ]])
	end,
})

-- Fixes Autocomment
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	callback = function()
		vim.cmd("set formatoptions-=cro")
	end,
})

-- Highlight Yanked Text
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
	end,
})
--tree close
--vim.cmd("autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif")
--vim.cmd("au InsertLeave * set nopaste")

--u.create_augroup({
--    { 'WinEnter', '*', 'set', 'cul' },
--    { 'WinLeave', '*', 'set', 'nocul' },
--}, 'BgHighlight')
