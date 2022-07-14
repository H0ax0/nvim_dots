local status_ok, impatient = pcall(require, "impatient")
if not status_ok then
	vim.notify("Impatient disabled", "error")
	return
end

impatient.enable_profile()
