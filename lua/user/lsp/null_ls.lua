local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	vim.notify("null-ls not found", "warn")
	return
end
local mason_registry_ok, mason_registry = pcall(require, "mason-registry")
if not mason_registry_ok then
	vim.notify("mason not installed", "warn")
	return
end

local custom_configs = {
	prettier = {
		extra_args = {
			"--no-semi",
			"--single-quote",
			"--jsx-single-quote",
		},
		extra_filetypes = { "toml" },
	},
	black = {
		extra_args = { "--fast" },
	},
}
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local sources = {}

for _, tool in ipairs(mason_registry.get_installed_package_names()) do
	local config = { command = tool }
	if custom_configs[tool] ~= nil then
		config.extra_args = custom_configs[tool].extra_args
	end
	for fmt, _ in pairs(require("null-ls.builtins._meta.formatting")) do
		if fmt == tool then
			table.insert(sources, null_ls.builtins.formatting[tool].with(config))
		end
	end
	for diag, _ in pairs(require("null-ls.builtins._meta.diagnostics")) do
		if diag == tool then
			table.insert(sources, null_ls.builtins.diagnostics[tool].with(config))
		end
	end
	for ca, _ in pairs(require("null-ls.builtins._meta.code_actions")) do
		if ca == tool then
			table.insert(sources, null_ls.builtins.code_actions[tool].with(config))
		end
	end
end
table.insert(sources, null_ls.builtins.code_actions.gitsigns)
null_ls.setup({
	debug = false,
	sources = sources,
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.formatting_sync()
				end,
			})
		end
	end,
})
