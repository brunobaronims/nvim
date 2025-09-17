vim.o.number = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.swapfile = false
vim.o.softtabstop = 4
vim.o.termguicolors = true
vim.o.winborder = "rounded"
vim.o.expandtab = true
vim.o.cmdheight = 0
vim.g.mapleader = " "
vim.diagnostic.config({ virtual_text = true })

vim.filetype.add({
    extension = {
        env = "dotenv",
    },
    filename = {
        [".env"] = "dotenv",
    },
    pattern = {
        ["%.env%.[%w_.-]+"] = "dotenv",
    },
})

vim.pack.add({
    { src = "https://github.com/bluz71/vim-moonfly-colors",                  name = "moonfly" },
    { src = 'https://github.com/neovim/nvim-lspconfig',                      version = "master" },
    { src = "https://github.com/mason-org/mason.nvim",                       version = "main" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim",             version = "main" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/akinsho/bufferline.nvim" },
    { src = "https://github.com/nvim-telescope/telescope-file-browser.nvim", version = "master" },
    { src = "https://github.com/nvim-telescope/telescope.nvim",              version = "master" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter",            version = "main" },
})

vim.pack.update()

require "mason".setup()
require "mason-lspconfig".setup({
    ensure_installed = {
        "lua_ls",
        "gopls",
        "tailwindcss",
        "cssls",
        "html",
        "ts_ls",
    }
})
require "bufferline".setup()
require "nvim-web-devicons".setup()
require "nvim-treesitter.install".update({ with_sync = true })()

vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        },
    },
})
vim.cmd("colorscheme moonfly")

require('autocmds')
require('keymaps')
require('plugins.telescope')
