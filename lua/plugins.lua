local fn = vim.fn

--Packer Bootstrap
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

local status_ok, packer = pcall(require, "packer")
if not status_ok then
    vim.notify("packer not found!")
  return
end

packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

return packer.startup(function(use)
  use "wbthomason/packer.nvim"
  --use "nvim-lua/popup.nvim"
  --use "nvim-lua/plenary.nvim"
  use { "sonph/onehalf", rtp = "vim"}
  use { "neoclide/coc.nvim", branch = "release" }
  use "nvim-lualine/lualine.nvim"
  use "kristijanhusak/defx-git"
  use "kristijanhusak/defx-icons"
  use { "nvim-treesitter/nvim-treesitter" } --, do = ':TSUpdate' }
  use "windwp/nvim-autopairs"
  use "preservim/nerdtree"
  use "Xuyuanp/nerdtree-git-plugin"
  use "ryanoasis/vim-devicons"
  use "xiyaowong/nvim-transparent"
  use "towolf/vim-helm"


  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
