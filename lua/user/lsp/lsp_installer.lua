local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	vim.notify("lsp installer not found")
	return
end

lsp_installer.setup()
local servers_mod_ok, servers_mod = pcall(require, "nvim-lsp-installer.servers")
if not servers_mod_ok then
	vim.notify("lsp installer server submodule not found")
	return
end
local servers = servers_mod.get_installed_server_names()

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}

	if server == "sumneko_lua" then
		local sumneko_opts = require("user.lsp.settings.sumneko_lua")
		opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
	end

	if server == "pyright" then
		local pyright_opts = require("user.lsp.settings.pyright")
		opts = vim.tbl_deep_extend("force", pyright_opts, opts)
	end

	if server == "jsonls" then
		local jsonls_opts = require("user.lsp.settings.jsonls")
		opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
	end

	lspconfig[server].setup(opts)
end
