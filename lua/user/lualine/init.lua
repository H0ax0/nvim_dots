local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	vim.notify("No lualine available")
	return
end

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
	colored = false,
	always_visible = true,
}

local diff = {
	"diff",
	colored = false,
	symbols = { added = "", modified = "", removed = "" }, -- changes diff symbols
	cond = hide_in_width,
}

local filetype = {
	"filetype",
	icons_enabled = false,
}

local location = {
	"location",
	padding = 0,
}

local spaces = function()
	return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

local lsp_status_progress_ok, _ = pcall(require, "lualine.components.lsp_progress")
local progress_lsp = {}
if lsp_status_progress_ok then
	progress_lsp = {
		"lsp_progress",
		separators = {
			message = { pre = "", post = "" },
		},
		display_components = { "lsp_client_name", "spinner" },
		timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
		spinner_symbols = { "🌑 ", "🌒 ", "🌓 ", "🌔 ", "🌕 ", "🌖 ", "🌗 ", "🌘 " },
	}
else
	vim.notify("lualine progress component not found")
end

lualine.setup({
	options = {
		globalstatus = true,
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "alpha", "dashboard" },
		always_divide_middle = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = { diagnostics },
		lualine_x = { progress_lsp, diff, spaces, "encoding", filetype },
		lualine_y = { location },
		lualine_z = { "progress" },
	},
})
