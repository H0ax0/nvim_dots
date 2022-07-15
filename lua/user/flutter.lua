local flutter_tools_ok, flutter_tools = pcall(require, "flutter-tools")
if not flutter_tools_ok then
	vim.notify("flutter tools not installed", "info")
	return
end

flutter_tools.setup({
	ui = {
		border = "rounded",
		notification_style = "native",
	},
	decorations = {
		statusline = {
			app_version = false,
			device = false,
		},
	},
	debugger = { -- integrate with nvim dap + install dart code debugger
		enabled = true,
		run_via_dap = false, -- use dap instead of a plenary job to run flutter apps
	},
	fvm = false,
	widget_guides = {
		enabled = false,
	},
	closing_tags = {
		highlight = "ErrorMsg",
		prefix = ">",
		enabled = true,
	},
	dev_log = {
		enabled = true,
		open_cmd = "tabedit", -- command to use to open the log buffer
	},
	dev_tools = {
		autostart = false, -- autostart devtools server if not detected
		auto_open_browser = false, -- Automatically opens devtools in the browser
	},
	outline = {
		open_cmd = "30vnew", -- command to use to open the outline buffer
		auto_open = false, -- if true this will open the outline automatically when it is first populated
	},
	lsp = {
		color = { -- show the derived colours for dart variables
			enabled = false, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
			background = false, -- highlight the background
			foreground = false, -- highlight the foreground
			virtual_text = true, -- show the highlight using virtual text
			virtual_text_str = "■", -- the virtual text character to highlight
		},
		settings = {
			showTodos = true,
			completeFunctionCalls = true,
			renameFilesWithClasses = "prompt", -- "always"
			enableSnippets = true,
		},
	},
})
