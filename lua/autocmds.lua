vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        (vim.hl or vim.highlight).on_yank()
    end,
})

-- vim.api.nvim_create_autocmd('LspAttach', {
--     group = vim.api.nvim_create_augroup('my.lsp', {}),
--     callback = function(args)
--         local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
--         if client:supports_method('textDocument/completion') then
--             -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
--             -- client.server_capabilities.completionProvider.triggerCharacters = chars
--             vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true, debounce = 75 })
--         end
--     end,
-- })

vim.api.nvim_create_autocmd('FileType', {
    pattern = {
        "typescript",
        "typescriptreact",
        "zig",
        "lua",
        "go",
        "c",
        "vim",
        "vimdoc",
        "javascript",
        "html",
        "regex",
        "bash",
        "markdown",
        "markdown_inline",
    },
    callback = function() vim.treesitter.start() end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "checkhealth",
        "grug-far",
        "help",
        "lspinfo",
        "notify",
        "snacks_win",
        "TelescopePrompt",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.schedule(function()
            vim.keymap.set("n", "q", function()
                vim.cmd("close!")
                pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
            end, {
                buffer = event.buf,
                silent = true,
                desc = "Quit buffer",
            })
        end)
    end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "json", "jsonc", "json5" },
    callback = function()
        vim.opt_local.conceallevel = 0
    end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    callback = function(event)
        if event.match:match("^%w%w+:[\\/][\\/]") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})
