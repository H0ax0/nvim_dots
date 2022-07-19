local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	vim.notify("alpha not installed", "info")
	return
end

local hoax = require("user.alpha.hoax")
alpha.setup(hoax.config)
