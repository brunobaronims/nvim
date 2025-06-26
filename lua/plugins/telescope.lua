return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-fzf-native.nvim",
        { "nvim-telescope/telescope-file-browser.nvim", config = function() end },
    },
    keys = {
        {
            "sf",
            function()
                local telescope = require("telescope")
                local function telescope_buffer_dir()
                    return vim.fn.expand("%:p:h")
                end
                telescope.extensions.file_browser.file_browser({
                    path = telescope_buffer_dir(),
                    cwd = telescope_buffer_dir(),
                    respect_gitignore = false,
                    hidden = true,
                    grouped = true,
                    previewer = false,
                    initial_mode = "normal",
                    layout_config = { height = 40 },
                })
            end,
            desc = "File Browser",
        },
        {
            "<leader>ff",
            function()
                local builtin = require("telescope.builtin")
                builtin.find_files({
                    prompt_title = "Search Root",
                    hidden = true,
                    cwd = "/",
                    find_command = { "fd", "--type", "f", "--no-ignore", "--exclude", "mnt", "--exclude", "node_modules", "--exclude", ".git" },
                })
            end,
            desc = "Find Files",
        },
        {
            "<leader><leader>",
            function()
                local builtin = require("telescope.builtin")

                local buffer_dir = vim.fn.expand("%:p:h")

                local git_root = vim.fn.systemlist("git -C " .. buffer_dir .. " rev-parse --show-toplevel")[1]

                if git_root and vim.fn.isdirectory(git_root) ~= 0 then
                    builtin.find_files({
                        cwd = git_root,
                        prompt_title = "Search Git Root",
                        hidden = true,
                        find_command = {
                            "fd", "--type", "f", "--no-ignore",
                            "--exclude", "node_modules",
                            "--exclude", ".git",
                        },
                    })
                else
                    builtin.find_files({
                        cwd = buffer_dir,
                        prompt_title = "Search Current Dir",
                        hidden = true,
                        find_command = {
                            "fd", "--type", "f", "--no-ignore",
                            "--exclude", "node_modules",
                            "--exclude", ".git",
                        },
                    })
                end
            end,
            desc = "Find Files",
        },
        {
            "<leader>/",
            function()
                local builtin = require("telescope.builtin")

                local buffer_dir = vim.fn.expand("%:p:h")

                local git_root = vim.fn.systemlist("git -C " .. buffer_dir .. " rev-parse --show-toplevel")[1]

                if git_root and vim.fn.isdirectory(git_root) ~= 0 then
                    builtin.live_grep({
                        cwd = git_root,
                        vimgrep_arguments = {
                            "rg",
                            "--color=never",
                            "--no-heading",
                            "--with-filename",
                            "--line-number",
                            "--column",
                            "--smart-case",
                            "-uu",
                            "--glob",
                            "!node_modules/**",
                            "--glob", "!.git/**",
                        },
                        prompt_title = "Grep Git Root",
                    })
                else
                    builtin.live_grep({
                        cwd = buffer_dir,
                        vimgrep_arguments = {
                            "rg",
                            "--color=never",
                            "--no-heading",
                            "--with-filename",
                            "--line-number",
                            "--column",
                            "--smart-case",
                            "-uu",
                            "--glob",
                            "!node_modules/**",
                            "--glob", "!.git/**",
                        },
                        prompt_title = "Grep Current Dir",
                    })
                end
            end,
        },
    },
    config = function(_, opts)
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local fb_actions = telescope.extensions.file_browser.actions

        opts.extensions = {
            file_browser = {
                theme = "dropdown",
                hijack_netrw = true,
                mappings = {
                    ["n"] = {
                        ["N"] = fb_actions.create,
                        ["h"] = fb_actions.goto_parent_dir,
                        ["/"] = function()
                            vim.cmd("startinsert")
                        end,
                        ["<C-u>"] = function(prompt_bufnr)
                            for _ = 1, 10 do
                                actions.move_selection_previous(prompt_bufnr)
                            end
                        end,
                        ["<C-d>"] = function(prompt_bufnr)
                            for _ = 1, 10 do
                                actions.move_selection_next(prompt_bufnr)
                            end
                        end,
                    },
                },
            },
        }

        telescope.setup(opts)
        require("telescope").load_extension("fzf")
        require("telescope").load_extension("file_browser")
    end,
}
