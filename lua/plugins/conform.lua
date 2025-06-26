return {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>cf",
            function()
                require("conform").format({ async = true })
            end,
            mode = "",
            desc = "Format buffer",
        },
    },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            go = { "goimports" },
            html = { "prettierd", "prettier" },
            yaml = { "yamlfmt" },
            typescript = { "prettierd", "prettier" },
            typescriptreact = { "prettierd", "prettier" },
        },
        default_format_opts = {
            timeout_ms = 3000,
            async = false,
            quiet = false,
            lsp_format = "fallback",
        },
        format_on_save = { timeout_ms = 1000 },
    },
}
