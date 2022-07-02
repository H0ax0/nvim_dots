local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
	return
end

local function is_ft(b, ft)
	return vim.bo[b].filetype == ft
end

local function diagnostics_indicator(num, _, diagnostics, _)
	local result = {}
	local symbols = { error = "", warning = "", info = "" }
	for name, count in pairs(diagnostics) do
		if symbols[name] and count > 0 then
			table.insert(result, symbols[name] .. " " .. count)
		end
	end
	result = table.concat(result, " ")
	return #result > 0 and result or ""
end

local function custom_filter(buf, buf_nums)
	local logs = vim.tbl_filter(function(b)
		return is_ft(b, "log")
	end, buf_nums)
	if vim.tbl_isempty(logs) then
		return true
	end
	local tab_num = vim.fn.tabpagenr()
	local last_tab = vim.fn.tabpagenr("$")
	local is_log = is_ft(buf, "log")
	if last_tab == 1 then
		return true
	end
	-- only show log buffers in secondary tabs
	return (tab_num == last_tab and is_log) or (tab_num ~= last_tab and not is_log)
end

local close_action = "bdelete! %d"
local bufdel_ok, bufdel = pcall(require, "bufdelete")
if not bufdel_ok then
	vim.notify("no bufdelete installed, using " .. close_action)
else
	close_action = function(bufnum)
		bufdel.bufdelete(bufnum, true)
	end
end

bufferline.setup({
	options = {
		numbers = "none", -- can be "none" | "ordinal" | "buffer_id" | "both" | function
		close_command = close_action, -- can be a string | function, see "Mouse actions"
		right_mouse_command = "vert sbuffer %d", -- can be a string | function, see "Mouse actions"
		left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
		middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
		indicator_icon = "▎",
		buffer_close_icon = "",
		modified_icon = "●",
		close_icon = "",
		left_trunc_marker = "",
		right_trunc_marker = "",
		name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
			if buf.name:match("%.md") then
				return vim.fn.fnamemodify(buf.name, ":t:r")
			end
		end,
		max_name_length = 18,
		max_prefix_length = 15,
		tab_size = 18,
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false,
		diagnostics_indicator = diagnostics_indicator,
		custom_filter = custom_filter,
		offsets = {
			{
				filetype = "undotree",
				text = "Undotree",
				highlight = "PanelHeading",
				padding = 1,
			},
			{
				filetype = "NvimTree",
				text = "Explorer",
				highlight = "PanelHeading",
				padding = 1,
			},
			{
				filetype = "DiffviewFiles",
				text = "Diff View",
				highlight = "PanelHeading",
				padding = 1,
			},
			{
				filetype = "flutterToolsOutline",
				text = "Flutter Outline",
				highlight = "PanelHeading",
			},
			{
				filetype = "packer",
				text = "Packer",
				highlight = "PanelHeading",
				padding = 1,
			},
		},
		show_buffer_icons = true,
		show_buffer_close_icons = true,
		show_close_icon = false,
		show_tab_indicators = true,
		persist_buffer_sort = true,
		separator_style = "thin",
		enforce_regular_tabs = false,
		always_show_bufferline = false,
		sort_by = "id",
	},
	highlights = {
		fill = {
			guifg = { attribute = "fg", highlight = "#ff0000" },
			guibg = { attribute = "bg", highlight = "TabLine" },
		},
		background = {
			guifg = { attribute = "fg", highlight = "TabLine" },
			guibg = { attribute = "bg", highlight = "TabLine" },
		},

		buffer_visible = {
			guifg = { attribute = "fg", highlight = "TabLine" },
			guibg = { attribute = "bg", highlight = "TabLine" },
		},

		close_button = {
			guifg = { attribute = "fg", highlight = "TabLine" },
			guibg = { attribute = "bg", highlight = "TabLine" },
		},
		close_button_visible = {
			guifg = { attribute = "fg", highlight = "TabLine" },
			guibg = { attribute = "bg", highlight = "TabLine" },
		},

		tab_selected = {
			guifg = { attribute = "fg", highlight = "Normal" },
			guibg = { attribute = "bg", highlight = "Normal" },
		},
		tab = {
			guifg = { attribute = "fg", highlight = "TabLine" },
			guibg = { attribute = "bg", highlight = "TabLine" },
		},
		tab_close = {
			guifg = { attribute = "fg", highlight = "TabLineSel" },
			guibg = { attribute = "bg", highlight = "Normal" },
		},

		duplicate_selected = {
			guifg = { attribute = "fg", highlight = "TabLineSel" },
			guibg = { attribute = "bg", highlight = "TabLineSel" },
			gui = "italic",
		},
		duplicate_visible = {
			guifg = { attribute = "fg", highlight = "TabLine" },
			guibg = { attribute = "bg", highlight = "TabLine" },
			gui = "italic",
		},
		duplicate = {
			guifg = { attribute = "fg", highlight = "TabLine" },
			guibg = { attribute = "bg", highlight = "TabLine" },
			gui = "italic",
		},

		modified = {
			guifg = { attribute = "fg", highlight = "TabLine" },
			guibg = { attribute = "bg", highlight = "TabLine" },
		},
		modified_selected = {
			guifg = { attribute = "fg", highlight = "Normal" },
			guibg = { attribute = "bg", highlight = "Normal" },
		},
		modified_visible = {
			guifg = { attribute = "fg", highlight = "TabLine" },
			guibg = { attribute = "bg", highlight = "TabLine" },
		},

		separator = {
			guifg = { attribute = "bg", highlight = "TabLine" },
			guibg = { attribute = "bg", highlight = "TabLine" },
		},
		separator_selected = {
			guifg = { attribute = "bg", highlight = "Normal" },
			guibg = { attribute = "bg", highlight = "Normal" },
		},
		indicator_selected = {
			guifg = { attribute = "fg", highlight = "LspDiagnosticsDefaultHint" },
			guibg = { attribute = "bg", highlight = "Normal" },
		},
	},
})
