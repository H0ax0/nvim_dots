local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	vim.notify("lsp installer not found", "warn")
	return
end

lsp_installer.setup({
	ui = {
		border = "rounded",
	},
})

local servers_mod_ok, servers_mod = pcall(require, "nvim-lsp-installer.servers")
if not servers_mod_ok then
	vim.notify("lsp installer server submodule not found", "error")
	return
end

local servers = servers_mod.get_installed_server_names()

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	vim.notify("no lsp config", "error")
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

	if server == "clangd" then
		local clangd_opts = require("user.lsp.settings.clangd")
		opts = vim.tbl_deep_extend("force", clangd_opts, opts)
	end

	if server == "yamlls" then
		local yamlls_opts = require("user.lsp.settings.yamlls")
		opts = vim.tbl_deep_extend("force", yamlls_opts, opts)
	end

	if server == "jdtls" then
		goto continue
	end

	if server == "rust_analyzer" then
		local rust_opts = require("user.lsp.settings.rust")

		local rust_tools_status_ok, rust_tools = pcall(require, "rust-tools")
		if not rust_tools_status_ok then
			vim.notify("rust-tools not installed, using defalt lsp config", "info")
			return
		end

		rust_tools.setup(rust_opts)
		goto continue
	end

	if server == "dartls" then
		local flutter_tools_status_ok, _ = pcall(require, "flutter-tools")
		if not flutter_tools_status_ok then
			vim.notify("pure dart config", "warn")
			return
		end
		goto continue
	end
	lspconfig[server].setup(opts)
	::continue::
end
