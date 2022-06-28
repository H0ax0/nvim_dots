local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  vim.notify("no lspconfig!!")
  return
end

require "user.lsp.lsp_installer"
require("user.lsp.handlers").setup()
require "user.lsp.null_ls"
