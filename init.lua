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
vim.o.fileformats = { "unix", "dos" }
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
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
    { src = "https://github.com/echasnovski/mini.surround",       name = "surround" },
    { src = "https://github.com/akinsho/bufferline.nvim",         name = "bufferline" },
    { src = "https://github.com/folke/snacks.nvim",               name = "snacks",          version = "main" },
    { src = "https://github.com/folke/trouble.nvim",              name = "trouble",         version = "main" },
    { src = "https://github.com/MagicDuck/grug-far.nvim",         name = "grug",            version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", name = "treesitter",      version = "main" },
    { src = "https://github.com/nvim-mini/mini.pairs",            name = "pairs",           version = "main" },
    { src = "https://github.com/nvim-lualine/lualine.nvim",       name = "lualine",         version = "master" },
    { src = "https://github.com/saghen/blink.cmp",                name = "blink.cmp",       version = "v1.7.0" },
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
        "zls",
    }
})
require "mini.surround".setup({
    mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
    },
})
require "bufferline".setup()
require "grug-far".setup()
require "nvim-web-devicons".setup()
require "lualine".setup({})
local snacks = require("snacks")
if not snacks.did_setup then
    local function buffer_dir()
        local name = vim.api.nvim_buf_get_name(0)
        if name == "" then
            return vim.uv.cwd()
        end
        return vim.fs.dirname(vim.fn.fnamemodify(name, ":p"))
    end

    local function project_dir()
        local dir = buffer_dir()
        if not dir then
            return nil
        end
        local git_path = vim.fs.find(".git", { path = dir, upward = true })[1]
        if git_path then
            local git_parent = vim.fs.dirname(git_path)
            if git_parent and git_parent ~= "" then
                return git_parent
            end
        end
        return dir
    end

    local e = {
        "**/node_modules/**",
        "**/dist/**",
        "**/build/**",
        "**/.git/**",
        "**/.cache/**",
        "**/.venv/**",
        "**/.next/**",
        "**/target/**",
    }

    snacks.setup({
        picker = {
            hidden = true,
            ignored = true,
            config = function(opts)
                if not opts.cwd then
                    opts.cwd = project_dir() or buffer_dir()
                end
                return opts
            end,
            sources = {
                explorer = {
                    cmd = "fd",
                    config = function(opts)
                        if not opts.cwd then
                            opts.cwd = buffer_dir()
                        end
                        return require("snacks.picker.source.explorer").setup(opts)
                    end,
                    follow_file = false,
                    auto_close = true,
                    exclude = e,
                },
                grep = {
                    exclude = e,
                },
                files = {
                    cmd = "fd",
                    exclude = e,
                }
            },
        },
        scroll = {
            enabled = true,
            animate = {
                duration = { step = 10, total = 100 },
                easing = "linear",
            },
            animate_repeat = {
                delay = 50,
                duration = { step = 3, total = 20 },
                easing = "linear",
            },
        },
        bufdelete = {},
        lazygit = {},
        terminal = {},
        indent = {},
        notifier = {},
        explorer = { replace_netrw = true },
    })
end
require 'nvim-treesitter'.setup {
    install_dir = vim.fn.stdpath('data') .. '/parser'
}
require "nvim-treesitter".install({
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
}):wait(30000)
require "mini.pairs".setup()
require "blink.cmp".setup({
    keymap = {
        preset = 'default',
        ['<CR>'] = { 'accept', 'fallback' }
    },
    appearance = {
        nerd_font_variant = 'mono'
    },
    cmdline = {
        enabled = true,
        completion = {
            menu = {
                auto_show = true
            },
        },
    },
    completion = {
        documentation = {
            auto_show = true
        },
        ghost_text = { enabled = true }
    },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'cmdline' },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" }
})
require "trouble".setup()

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
