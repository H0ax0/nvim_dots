local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	vim.notify("null-ls not found")
	return
end

local formatter_install_ok, formatter_install = pcall(require, "format-installer")
if not formatter_install_ok then
	vim.notify("formatter_installer not installed")
	return
end
formatter_install.setup({ installation_path = vim.fn.stdpath("data") .. "/formatters/" })

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

for _, formatter in ipairs(formatter_install.get_installed_formatters()) do
	local config = { command = formatter.cmd }
	if custom_configs[formatter.name] ~= nil then
		config.extra_args = custom_configs[formatter.name].extra_args
	end
	table.insert(sources, null_ls.builtins.formatting[formatter.name].with(config))
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
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					vim.lsp.buf.formatting_sync()
				end,
			})
		end
	end,
})
