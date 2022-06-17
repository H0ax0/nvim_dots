local map = vim.api.nvim_set_keymap

local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

map('n', '<S-C-p>', '', opts)
map('n', '<leader>d', '', opts)

