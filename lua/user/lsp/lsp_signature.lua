local status_ok, signature = pcall(require, "lsp_signature")
if not status_ok then
	vim.notify("lsp signature not installed", "info")
	return
end

local cfg = {
	bind = true,
	doc_lines = 8,
	floating_window = false,
	floating_window_above_cur_line = false,
	fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
	hint_enable = true,
	hint_prefix = "  ",
	hint_scheme = "Comment",
	hi_parameter = "LspSignatureActiveParameter",
	max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
	max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
	handler_opts = {
		border = "rounded", -- double, rounded, single, shadow, none
	},
	always_trigger = false,
	auto_close_after = nil,
	extra_trigger_chars = {},
	zindex = 200,
	padding = "",
	transparency = 40,
	shadow_blend = 36, -- if you using shadow as border use this set the opacity
	shadow_guibg = "Black",
	timer_interval = 200,
	toggle_key = nil,
}
signature.setup(cfg) -- no need to specify bufnr if you don't use toggle_key
signature.on_attach(cfg) -- no need to specify bufnr if you don't use toggle_key
