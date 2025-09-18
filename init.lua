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

local plugins = {
    { src = "https://github.com/bluz71/vim-moonfly-colors",       name = "moonfly" },
    { src = "https://github.com/neovim/nvim-lspconfig",           name = "lspconfig",       version = "master" },
    { src = "https://github.com/mason-org/mason.nvim",            name = "mason",           version = "main" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim",  name = "mason-lspconfig", version = "main" },
    { src = "https://github.com/nvim-lua/plenary.nvim",           name = "plenary" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons",     name = "devicons" },
    { src = "https://github.com/akinsho/bufferline.nvim",         name = "bufferline" },
    { src = "https://github.com/folke/snacks.nvim",               name = "snacks",          version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", name = "treesitter",      version = "main" },
}

vim.pack.add(plugins)

local managed = {}
for _, spec in ipairs(plugins) do
    local name = spec.name
    if name then
        managed[name] = true
    end
end

local stale = {}
for _, plug in ipairs(vim.pack.get()) do
    local name = plug.spec.name
    if name and not managed[name] then
        table.insert(stale, name)
    end
end

if #stale > 0 then
    vim.pack.del(stale)
end

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
local snacks = require("snacks")
if not snacks.did_setup then
    local function buffer_dir()
        local name = vim.api.nvim_buf_get_name(0)
        if name == "" then
            return vim.uv.cwd()
        end
        return vim.fs.dirname(vim.fn.fnamemodify(name, ":p"))
    end

    snacks.setup({
        picker = {
            hidden = true,
            config = function(opts)
                if not opts.cwd then
                    opts.cwd = buffer_dir()
                end
                return opts
            end,
            sources = {
                explorer = {
                    auto_close = true,
                },
            },
        },
        explorer = {},
        bufdelete = {},
        lazygit = {},
        terminal = {},
    })
end
require "nvim-treesitter".install {
    "c",
    "lua",
    "vim",
    "vimdoc",
    "javascript",
    "jsx",
    "tsx",
    "typescript",
    "html",
    "go",
    "regex",
    "bash",
    "markdown",
    "markdown_inline",
    "zig",
}

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
