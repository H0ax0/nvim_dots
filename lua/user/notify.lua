local notify_ok, notify = pcall(require, "notify")
if not notify_ok then
	vim.notify("notify not installed")
	return
end

notify.setup({
	background_colour = "#000000",
})
vim.notify = notify
