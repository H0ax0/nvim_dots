--code_actions ui
vim.g.code_action_menu_window_border = "single"
vim.g.code_action_menu_show_details = true
vim.g.code_action_menu_show_diff = true

local lightbulb_ok, lightbulb = pcall(require, "nvim-lightbulb")
if not lightbulb_ok then
	vim.notify("Lightbulb 💡ﯧﯦ not installed", "info")
	return
end

lightbulb.setup({
	ignore = {},
	sign = { enabled = true, priority = 10 },
	float = {
		enabled = false,
	},
	virtual_text = {
		enabled = false,
		text = "",
		-- highlight mode to use for virtual text (replace, combine, blend)
		hl_mode = "replace",
	},
	status_text = {
		enabled = true,
		text = "",
		text_unavailable = "",
	},
	autocmd = {
		enabled = true,
		pattern = { "*" },
		events = { "CursorHold", "CursorHoldI" },
	},
})

vim.api.nvim_set_hl(0, "LightBulbHlSignText", { fg = "#da9cd9" }) --#da9cd9 #95be93
vim.fn.sign_define("LightBulbSign", { text = "", texthl = "LightBulbHlSignText", linehl = "", numhl = "" })
