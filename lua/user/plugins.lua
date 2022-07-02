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
	vim.notify("packer not found!")
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
	use("williamboman/nvim-lsp-installer") -- simple to use language server installer
	-- formatter
	use("PlatyPew/format-installer.nvim")
	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = "PlatyPew/format-installer.nvim",
	})
	--line
	use("nvim-lualine/lualine.nvim")
	--treesitter
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	--autopairs
	use("windwp/nvim-autopairs")
	--nvim_tree
	use({ "kyazdani42/nvim-tree.lua", requires = { "kyazdani42/nvim-web-devicons" }, tag = "nightly" })
	--helm stuff
	use("towolf/vim-helm")
	--colorscheme
	use("http://truenas.local:10036/hoax/onehalf.nvim.git")
	--dap
	use("mfussenegger/nvim-dap")
	use("rcarriga/nvim-dap-ui")
	use("ravenxrz/DAPInstall.nvim")
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
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
