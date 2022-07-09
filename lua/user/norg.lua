local norg_ok, norg = pcall(require, "neorg")
if not norg_ok then
	vim.notify("norg norg installed")
	return
end

norg.setup()
