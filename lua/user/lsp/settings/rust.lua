local extension_path = vim.fn.stdpath("data") .. "/dapinstall/codelldb/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

return {
	tools = {
		autoSetHints = true,
		hover_with_actions = true,
		on_initialized = function()
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
				pattern = { "*.rs" },
				callback = function()
					vim.lsp.codelens.refresh()
				end,
			})
		end,
		inlay_hints = {
			only_current_line = false,
			only_current_line_autocmd = "CursorHold",
			show_parameter_hints = false,
			show_variable_name = false,
			parameter_hints_prefix = " ",
			other_hints_prefix = " ",
			max_len_align = false,
			max_len_align_padding = 1,
			right_align = false,
			right_align_padding = 7,
			highlight = "Comment",
		},
		hover_actions = {
			auto_focus = false,
			border = "rounded",
			width = 60,
			-- height = 30,
		},
	},
	server = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,

		settings = {
			["rust-analyzer"] = {
				lens = {
					enable = true,
				},
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	},
	dap = {
		adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
	},
}
