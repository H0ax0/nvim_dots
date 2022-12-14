local M = {}

M.capabilities = vim.lsp.protocol.make_client_capabilities()

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
	vim.notify("cmp_nvim_lsp not installed", "error")
	return
end

M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.update_capabilities(M.capabilities)

M.setup = function()
	local signs = {

		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		virtual_text = true,
		signs = { active = signs },
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
		width = 60,
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
		width = 60,
	})
end

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap
	keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	keymap(bufnr, "n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
end

M.on_attach = function(client, bufnr)
	if client.name == "tsserver" then
		client.resolved_capabilities.document_formatting = false
	end

	if client.name == "jdt.ls" then
		if JAVA_DAP_ACTIVE then
			require("jdtls").setup_dap({ hotcodereplace = "auto" })
			require("jdtls.dap").setup_dap_main_class_configs()
		end
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.textDocument.completion.completionItem.snippetSupport = false
		vim.lsp.codelens.refresh()
	end

	if client.name == "sumneko_lua" then
		client.resolved_capabilities.document_formatting = false
	end

	if client.name == "rust_analyzer" then
		client.resolved_capabilities.document_formatting = false
	end

	if client.name == "kotlin_language_server" then
		client.resolved_capabilities.document_formatting = false
	end

	if client.name == "gopls" then
		client.resolved_capabilities.document_formatting = false
	end

	if client.name == "denols" then
		client.resolved_capabilities.document_formatting = false
	end

	if client.name == "clangd" then
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.offsetEncoding = { "utf-8" }
	end

	M.capabilities.textDocument.completion.completionItem.snippetSupport = true

	lsp_keymaps(bufnr)

	local status_ok, illuminate = pcall(require, "illuminate")
	if not status_ok then
		vim.notify("illumite not installed", "info")
		return
	end
	illuminate.on_attach(client)
end

return M
