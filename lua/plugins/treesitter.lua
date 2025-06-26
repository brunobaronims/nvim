return {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        priority = 1000,
        opts = {
                ensure_installed = {
                        "c",
                        "lua",
                        "vim",
                        "vimdoc",
                        "javascript",
                        "html",
                        "go",
                        "regex",
                        "bash",
                        "markdown",
                        "markdown_inline",
                },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
                modules = {},
                ignore_install = {},
                auto_install = true,
        },
        config = function(_, opts)
                require("nvim-treesitter.configs").setup(opts)
        end,
}
