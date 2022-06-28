local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
	vim.notify("no dap plugin installed")
	return
end

local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
	vim.notify("no dap plugin ui installed")
	return
end

local dap_install_status_ok, dap_install = pcall(require, "dap-install")
if not dap_install_status_ok then
	vim.notify("no dap installer")
	return
end

dap_install.setup({})
dap_install.config("python", {})

vim.fn.sign_define("DapBreakpoint", {
	text = "",
	texthl = "LspDiagnosticsSignError",
	linehl = "",
	numhl = "",
})
vim.fn.sign_define("DapBreakpointRejected", {
	text = "",
	texthl = "LspDiagnosticsSignHint",
	linehl = "",
	numhl = "",
})
vim.fn.sign_define("DapStopped", {
	text = "",
	texthl = "LspDiagnosticsSignInformation",
	linehl = "DiagnosticUnderlineInfo",
	numhl = "LspDiagnosticsSignInformation",
})

dapui.setup({
	icons = { expanded = "▾", collapsed = "▸" },
	mappings = {
		-- Use a table to apply multiple mappings
		expand = { "<CR>", "<2-LeftMouse>" },
		open = "o",
		remove = "d",
		edit = "e",
		repl = "r",
		toggle = "t",
	},
	expand_lines = true,
	-- Layouts define sections of the screen to place windows.
	-- The position can be "left", "right", "top" or "bottom".
	-- The size specifies the height/width depending on position.
	-- Elements are the elements shown in the layout (in order).
	-- Layouts are opened in order so that earlier layouts take priority in window sizing.
	layouts = {
		{
			elements = {
				-- Elements can be strings or table with id and size keys.
				{ id = "scopes", size = 0.25 },
				"breakpoints",
				"stacks",
				"watches",
			},
			size = 40,
			position = "left",
		},
		{
			elements = {
				"repl",
				"console",
			},
			size = 10,
			position = "bottom",
		},
	},
	floating = {
		max_height = nil, -- These can be integers or a float between 0 and 1.
		max_width = nil, -- Floats will be treated as percentage of your screen.
		border = "single", -- Border style. Can be "single", "double" or "rounded"
		mappings = {
			close = { "q", "<Esc>" },
		},
	},
	windows = { indent = 1 },
	render = {
		max_type_length = nil, -- Can be integer or nil.
	},
})

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
