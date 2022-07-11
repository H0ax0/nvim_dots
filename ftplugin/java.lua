--add ignore
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.cmdheight = 2 -- more space in the neovim command line for displaying messages

local status, jdtls = pcall(require, "jdtls")
if not status then
	vim.notify("no jdtls installed detected by ftplugin")
	return
end

local home = os.getenv("HOME")
WORKSPACE_PATH = home .. "/workspace/"
CONFIG = "linux"
-- Find root of project
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
	return
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local workspace_dir = WORKSPACE_PATH .. project_name

JAVA_DAP_ACTIVE = true

local bundles = {
	vim.fn.glob(
		home .. "/.config/nvim/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
	),
}

vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/.config/nvim/vscode-java-test/server/*.jar"), "\n"))

local config = {
	cmd = {
		"/usr/lib/jvm/java-17-openjdk-amd64/bin/java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-javaagent:" .. home .. "/.local/share/nvim/lsp_servers/jdtls/lombok.jar",
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-jar",
		vim.fn.glob(home .. "/.local/share/nvim/lsp_servers/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
		"-configuration",
		home .. "/.local/share/nvim/lsp_servers/jdtls/config_" .. CONFIG,
		"-data",
		workspace_dir,
	},

	on_attach = require("user.lsp.handlers").on_attach,
	capabilities = require("user.lsp.handlers").capabilities,
	root_dir = root_dir,
	settings = {
		java = {
			-- jdt = {
			--   ls = {
			--     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
			--   }
			-- },
			eclipse = {
				downloadSources = true,
			},
			configuration = {
				updateBuildConfiguration = "interactive",
			},
			maven = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			references = {
				includeDecompiledSources = true,
			},
			format = {
				enabled = false,
				-- settings = {
				--   profile = "asdf"
				-- }
			},
		},
		signatureHelp = { enabled = true },
		completion = {
			favoriteStaticMembers = {
				"org.hamcrest.MatcherAssert.assertThat",
				"org.hamcrest.Matchers.*",
				"org.hamcrest.CoreMatchers.*",
				"org.junit.jupiter.api.Assertions.*",
				"java.util.Objects.requireNonNull",
				"java.util.Objects.requireNonNullElse",
				"org.mockito.Mockito.*",
			},
		},
		contentProvider = { preferred = "fernflower" },
		extendedClientCapabilities = extendedClientCapabilities,
		sources = {
			organizeImports = {
				starThreshold = 9999,
				staticStarThreshold = 9999,
			},
		},
		codeGeneration = {
			toString = {
				template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
			},
			useBlocks = true,
		},
		configuration = {
			runtimes = {
				{
					name = "JavaSE-8",
					path = "/usr/lib/jvm/java-8-openjdk-amd64",
				},
				{
					name = "JavaSE-11",
					path = "/usr/lib/jvm/java-11-openjdk-amd64",
				},
				{
					name = "JavaSE-17",
					path = "/usr/lib/jvm/java-17-openjdk-amd64",
				},
			},
		},
	},

	flags = {
		allow_incremental_sync = true,
	},

	-- Language server `initializationOptions`
	-- You need to extend the `bundles` with paths to jar files
	-- if you want to use additional eclipse.jdt.ls plugins.
	--
	-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
	--
	-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
	init_options = {
		-- bundles = {},
		bundles = bundles,
	},
}

require("jdtls").start_or_attach(config)

vim.cmd(
	"command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
)
vim.cmd(
	"command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)"
)
vim.cmd("command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()")
-- vim.cmd "command! -buffer JdtJol lua require('jdtls').jol()"
vim.cmd("command! -buffer JdtBytecode lua require('jdtls').javap()")
-- vim.cmd "command! -buffer JdtJshell lua require('jdtls').jshell()"

-- local status_ok, which_key = pcall(require, "which-key")
-- if not status_ok then
--   return
-- end
--
-- local opts = {
--   mode = "n", -- NORMAL mode
--   prefix = "<leader>",
--   buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
--   silent = true, -- use `silent` when creating keymaps
--   noremap = true, -- use `noremap` when creating keymaps
--   nowait = true, -- use `nowait` when creating keymaps
-- }
--
-- local vopts = {
--   mode = "v", -- VISUAL mode
--   prefix = "<leader>",
--   buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
--   silent = true, -- use `silent` when creating keymaps
--   noremap = true, -- use `noremap` when creating keymaps
--   nowait = true, -- use `nowait` when creating keymaps
-- }
--
-- local mappings = {
--   j = {
--     name = "Java",
--     o = { "<Cmd>lua require'jdtls'.organize_imports()<CR>", "Organize Imports" },
--     v = { "<Cmd>lua require('jdtls').extract_variable()<CR>", "Extract Variable" },
--     c = { "<Cmd>lua require('jdtls').extract_constant()<CR>", "Extract Constant" },
--     t = { "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", "Test Method" },
--     T = { "<Cmd>lua require'jdtls'.test_class()<CR>", "Test Class" },
--     u = { "<Cmd>JdtUpdateConfig<CR>", "Update Config" },
--   },
-- }
--
-- local vmappings = {
--   j = {
--     name = "Java",
--     v = { "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", "Extract Variable" },
--     c = { "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", "Extract Constant" },
--     m = { "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", "Extract Method" },
--   },
-- }
--
-- which_key.register(mappings, opts)
-- which_key.register(vmappings, vopts)

-- debugging
-- git clone git@github.com:microsoft/java-debug.git
