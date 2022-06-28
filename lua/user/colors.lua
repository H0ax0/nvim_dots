local onedark_ok, onedark = pcall(require, "onedark")
if not onedark_ok then
	vim.notify("No color scheme")
	return
end
onedark.setup({ style = "halfdark" })
onedark.load()
