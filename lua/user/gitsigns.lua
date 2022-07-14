local gitsigns_cfg = {
	signs = {
		add = {
			hl = "GitSignsAdd",
			text = "+",
			numhl = "GitSignsAddNr",
			linehl = "GitSignsAddLn",
		},
		change = {
			hl = "GitSignsChange",
			text = "~",
			numhl = "GitSignsChangeNr",
			linehl = "GitSignsChangeLn",
		},
		delete = {
			hl = "GitSignsDelete",
			text = "✖",
			numhl = "GitSignsDeleteNr",
			linehl = "GitSignsDeleteLn",
		},
		topdelete = {
			hl = "GitSignsDelete",
			text = "☒",
			numhl = "GitSignsDeleteNr",
			linehl = "GitSignsDeleteLn",
		},
		changedelete = {
			hl = "GitSignsChange",
			text = "~",
			numhl = "GitSignsChangeNr",
			linehl = "GitSignsChangeLn",
		},
	},
	numhl = false,
	linehl = false,
	keymaps = {
		noremap = true,
		buffer = true,
	},
	signcolumn = true,
	word_diff = false,
	attach_to_untracked = true,
	current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
		ignore_whitespace = false,
	},
	current_line_blame_formatter_opts = {
		relative_time = false,
	},
	max_file_length = 40000,
	preview_config = {
		border = "rounded",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},
	watch_gitdir = {
		interval = 1000,
		follow_files = true,
	},
	sign_priority = 6,
	update_debounce = 200,
	status_formatter = nil, -- Use default
	yadm = { enable = false },
}

local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
if not gitsigns_ok then
	vim.notify("Gitsigns not installed", "warn")
	return
end

gitsigns.setup(gitsigns_cfg)
