local hover_ok, hover = pcall(require, "hover")
if not hover_ok then
	vim.notify("hover not installed", "info")
	return
end

hover.setup({
	init = function()
		require("hover.providers.lsp")
		require("hover.providers.gh")
		require("hover.providers.man")
		require("hover.providers.dictionary")
	end,
	preview_opts = {
		border = nil,
	},
	title = true,
})
vim.keymap.set("n", "gK", require("hover").hover, { desc = "hover.nvim" })
vim.keymap.set("n", "gS", require("hover").hover_select, { desc = "hover.nvim (select)" })
