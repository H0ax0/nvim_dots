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

local mason_registry_ok, mason_registry = pcall(require, "dapui")
if not mason_registry_ok then
	vim.notify("mason registry plugin not installed", "warn")
	return
end

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

local adapter_map = {
	python = {
		truename = "",
		special = false,
		path_extra = "/venv/bin/python",
		args = { "-m", "debugpy.adapter" },
	},
	go = {
		truename = "go-debug-adapter",
		spacial = false,
		path_extra = "/go-debug-adapter",
	},
	cppdbg = {
		truename = "cpptools",
		special = false,
		path_extra = "/extension/debugAdapters/bin/OpenDebugAD7",
	},
	codelldb = {
		truename = "",
		special = true,
		special_fun = function(on_adapter)
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
			local exec_path = ""
			local ins_ok, mason_lldb_pkg = pcall(mason_registry.get_package, "codelldb")
			if not ins_ok then
				vim.notify("DAP adapter codelldb not installed", "info")
			else
				exec_path = mason_lldb_pkg:get_install_path()
			end
			handle, pid_or_err = vim.loop.spawn(exec_path .. "/extension/adapter/codelldb", opts, function(code)
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
		end,
	},
}

for _, adapter in ipairs(adapter_map) do
	local current_adapter = {}
	if not adapter.special then
		local adapter_registed_ok, adapter_registed = pcall(mason_registry.get_package, adapter.truename)
		if not adapter_registed_ok then
			vim.notify("DAP adapter " .. adapter.truename .. " not installed", "info")
		else
			current_adapter = {
				type = "executable",
				command = adapter_registed:get_install_path() .. adapter.path_extra,
				args = adapter.args,
			}
		end
	else
		current_adapter = adapter.special_fun
	end
	dap.adapters[adapter] = current_adapter
end

dap.adapters.dart = {
	type = "executable",
	command = "node",
	args = { "/home/hoax/.local/share/nvim/dapinstall/dart/Dart-Code/out/dist/debug.js", "flutter" },
}
dap.configurations.dart = {
	{
		type = "dart",
		request = "launch",
		name = "Launch flutter",
		dartSdkPath = "/opt/flutter/bin/cache/dart-sdk/",
		flutterSdkPath = "/opt/flutter",
		program = "${workspaceFolder}/lib/main.dart",
		cwd = "${workspaceFolder}",
	},
}
