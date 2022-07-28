local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
	vim.notify("lsp installer not found", "warn")
	return
end

local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_ok then
	vim.notify("mason lspconfig not found", "warn")
	return
end

mason.setup({
	ui = {
		border = "rounded",
	},
})

mason_lspconfig.setup()

local servers = mason_lspconfig.get_installed_servers()

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	vim.notify("no lsp config", "error")
	return
end

local opts

for _, server in pairs(servers) do
	opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}

	if server == "sumneko_lua" then
		local sumneko_opts = require("user.lsp.settings.sumneko_lua")
		local l_status_ok, lua_dev = pcall(require, "lua-dev")
		if l_status_ok then
			local luadev = lua_dev.setup({
				lspconfig = {
					on_attach = opts.on_attach,
					capabilities = opts.capabilities,
					settings = sumneko_opts.settings,
				},
			})
			lspconfig.sumneko_lua.setup(luadev)
			goto continue
		else
			opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
			vim.notify("using default lua config", "info")
			lspconfig.sumneko_lua.setup(opts)
		end
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
