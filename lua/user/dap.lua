local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
	vim.notify("no dap plugin installed", "warn")
	return
end

local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
	vim.notify("no dap plugin ui installed", "warn")
	return
end

local dap_install_status_ok, dap_install = pcall(require, "dap-install")
if not dap_install_status_ok then
	vim.notify("no dap installer", "info")
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
	layouts = {
		sidebar = {
			-- You can change the order of elements in the sidebar
			elements = {
				-- Provide as ID strings or tables with "id" and "size" keys
				{
					id = "scopes",
					size = 0.25, -- Can be float or integer > 1
				},
				{ id = "breakpoints", size = 0.25 },
				-- { id = "stacks", size = 0.25 },
				-- { id = "watches", size = 00.25 },
			},
			size = 40,
			position = "right", -- Can be "left", "right", "top", "bottom"
		},
		tray = {
			elements = {},
			-- elements = { "repl" },
			-- size = 10,
			-- position = "bottom", -- Can be "left", "right", "top", "bottom"
		},
	},
	floating = {
		max_height = nil, -- These can be integers or a float between 0 and 1.
		max_width = nil, -- Floats will be treated as percentage of your screen.
		border = "rounded", -- Border style. Can be "single", "double" or "rounded"
		mappings = {
			close = { "q", "<Esc>" },
		},
	},
	windows = { indent = 1 },
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

local installation_path = vim.fn.stdpath("data") .. "/dapinstall/"

dap.adapters.python = {
	type = "executable",
	command = installation_path .. "python/bin/python",
	args = { "-m", "debugpy.adapter" },
}

dap.adapters.go = {
	type = "executable",
	command = "node",
	args = { installation_path .. "go/vscode-go/dist/debugAdapter.js" },
}

dap.adapters.cppdbg = {
	id = "cppdbg",
	type = "executable",
	command = installation_path .. "ccppr_vsc/extension/debugAdapters/bin/OpenDebugAD7",
}

dap.adapters.codelldb = function(on_adapter)
	local tcp = vim.loop.new_tcp()
	tcp:bind("127.0.0.1", 0)
	local port = tcp:getsockname().port
	tcp:shutdown()
	tcp:close()

	local stdout = vim.loop.new_pipe(false)
	local stderr = vim.loop.new_pipe(false)
	local opts = {
		stdio = { nil, stdout, stderr },
		args = { "--port", tostring(port) },
	}
	local handle
	local pid_or_err
	handle, pid_or_err = vim.loop.spawn(installation_path .. "codelldb/extension/adapter/codelldb", opts, function(code)
		stdout:close()
		stderr:close()
		handle:close()
		if code ~= 0 then
			print("codelldb exited with code", code)
		end
	end)
	if not handle then
		vim.notify("Error running codelldb: " .. tostring(pid_or_err), "error")
		stdout:close()
		stderr:close()
		return
	end
	vim.notify("codelldb started. pid=" .. pid_or_err, "info")
	stderr:read_start(function(err, chunk)
		assert(not err, err)
		if chunk then
			vim.schedule(function()
				require("dap.repl").append(chunk)
			end)
		end
	end)
	local adapter = {
		type = "server",
		host = "127.0.0.1",
		port = port,
	}
	-- 💀
	-- Wait for codelldb to get ready and start listening before telling nvim-dap to connect
	-- If you get connect errors, try to increase 500 to a higher value, or check the stderr (Open the REPL)
	vim.defer_fn(function()
		on_adapter(adapter)
	end, 500)
end
