local fn = vim.fn

--Packer Bootstrap
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

local status_ok, packer = pcall(require, "packer")
if not status_ok then
	vim.notify("packer not found!", "error")
	return
end

packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

return packer.startup(function(use)
	use("wbthomason/packer.nvim")
	use("nvim-lua/popup.nvim")
	use("nvim-lua/plenary.nvim")
	--cmp plugins
	use("hrsh7th/nvim-cmp") -- The completion plugin
	use("hrsh7th/cmp-buffer") -- buffer completions
	use("hrsh7th/cmp-path") -- path completions
	use("hrsh7th/cmp-nvim-lsp") -- lsp completions
	use("hrsh7th/cmp-emoji") -- emoji completions
	use("hrsh7th/cmp-nvim-lua") --lua nvim api completions
	use("saadparwaiz1/cmp_luasnip") -- snippet completions
	use("rcarriga/cmp-dap") -- dap completions
	use("RRethy/vim-illuminate") --illumination
	use("onsails/lspkind.nvim")
	--tabnine
	use({ "tzachar/cmp-tabnine", run = "./install.sh", requires = "hrsh7th/nvim-cmp" })
	-- snippets
	use("L3MON4D3/LuaSnip") --snippet engine
	use("rafamadriz/friendly-snippets") -- a bunch of snippets to use
	-- LSP
	use("neovim/nvim-lspconfig") -- enable LSP
	use({ "jose-elias-alvarez/null-ls.nvim" })
	--line
	use("nvim-lualine/lualine.nvim")
	--treesitter
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("JoosepAlviste/nvim-ts-context-commentstring")
	use("windwp/nvim-ts-autotag")
	--autopairs
	use("windwp/nvim-autopairs")
	--nvim_tree
	use({ "kyazdani42/nvim-tree.lua", requires = { "kyazdani42/nvim-web-devicons" }, tag = "nightly" })
	--mason
	use({ "williamboman/mason.nvim" })
	use("williamboman/mason-lspconfig.nvim")
	--helm stuff
	use("towolf/vim-helm")
	--colorscheme
	use("http://truenas.local:10036/hoax/onehalf.nvim.git")
	--dap
	use("mfussenegger/nvim-dap")
	use("rcarriga/nvim-dap-ui")
	use("theHamsta/nvim-dap-virtual-text")
	--impatient
	use("lewis6991/impatient.nvim")
	--bufferline
	use("akinsho/bufferline.nvim")
	-- Java
	use("mfussenegger/nvim-jdtls")
	--colorizer
	use("norcalli/nvim-colorizer.lua")
	--cursor hold
	use("antoinemadec/FixCursorHold.nvim")
	--bufdel for bufferline
	use("famiu/bufdelete.nvim")
	--schema store
	use("b0o/schemastore.nvim")
	--lualine lsp load progress
	use("arkav/lualine-lsp-progress")
	--gitsigns
	use("lewis6991/gitsigns.nvim")
	--telescope xdxd
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use({ "nvim-telescope/telescope-media-files.nvim", requieres = { "nvim-telescope/telescope.nvim" } })
	--norg
	use({ "nvim-neorg/neorg", requires = "nvim-lua/plenary.nvim" })
	--notify
	use("rcarriga/nvim-notify")
	--comments
	use("numToStr/Comment.nvim")
	--fidget
	use("j-hui/fidget.nvim")
	--dressing
	use("stevearc/dressing.nvim")
	--alpha
	use("goolord/alpha-nvim")
	--project
	use("ahmedkhalf/project.nvim")
	--la bruja
	use("folke/which-key.nvim")
	--the elder scroll
	use("karb94/neoscroll.nvim")
	--todo
	use("folke/todo-comments.nvim")
	--copilot-cmp source
	--use("zbirenbaum/copilot-cmp")
	--use({
	--	"zbirenbaum/copilot.lua",
	--	event = { "VimEnter" },
	--	config = function()
	--		vim.defer_fn(function()
	--			require("user.copilot")
	--		end, 100)
	--	end,
	--})
	--lsp signature -
	use("ray-x/lsp_signature.nvim")
	-- Rust
	use("simrat39/rust-tools.nvim")
	use("Saecki/crates.nvim")
	--code_actions
	use({ "weilbith/nvim-code-action-menu", cmd = "CodeActionMenu" })
	use({ "kosayoda/nvim-lightbulb", requires = "antoinemadec/FixCursorHold.nvim" })
	-- Typescript TODO: set this up, also add keybinds to ftplugin
	use("jose-elias-alvarez/typescript.nvim")
	--renamer
	use("filipdutescu/renamer.nvim")
	--flutter
	use({ "akinsho/flutter-tools.nvim", requires = "nvim-lua/plenary.nvim" })
	--clippy
	use({ "vappolinario/cmp-clippy", requires = "nvim-lua/plenary.nvim" })
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
