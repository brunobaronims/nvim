local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

telescope.setup({
  extensions = {
    file_browser = {
      theme = "dropdown",
      hijack_netrw = true,
      mappings = {
        ["n"] = {
          ["N"] = function(...) telescope.extensions.file_browser.actions.create(...) end,
          ["h"] = function(...) telescope.extensions.file_browser.actions.goto_parent_dir(...) end,
          ["/"] = function() vim.cmd("startinsert") end,
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
  },
})

telescope.load_extension("file_browser")

-- File browser (current buffer dir)
vim.keymap.set("n", "sf", function()
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
end, { desc = "File Browser" })

-- Find files (root)
vim.keymap.set("n", "<leader>ff", function()
  builtin.find_files({
    prompt_title = "Search Root",
    hidden = true,
    cwd = "/",
    find_command = {
      "fd", "--type", "f", "--no-ignore",
      "--exclude", "mnt", "--exclude", "**/node_modules",
      "--exclude", "**/.git",
    },
  })
end, { desc = "Find Files" })

-- Find files (git root or cwd)
vim.keymap.set("n", "<leader><leader>", function()
  local buffer_dir = vim.fn.expand("%:p:h")
  local git_root = vim.fn.systemlist("git -C " .. buffer_dir .. " rev-parse --show-toplevel")[1]

  local opts = {
    hidden = true,
    find_command = { "fd", "--type", "f", "--no-ignore", "--exclude", "**/node_modules", "--exclude", "**/.git" },
  }

  if git_root and vim.fn.isdirectory(git_root) ~= 0 then
    opts.cwd = git_root
    opts.prompt_title = "Search Git Root"
  else
    opts.cwd = buffer_dir
    opts.prompt_title = "Search Current Dir"
  end

  builtin.find_files(opts)
end, { desc = "Find Files" })

-- Live grep (git root or cwd)
vim.keymap.set("n", "<leader>/", function()
  local buffer_dir = vim.fn.expand("%:p:h")
  local git_root = vim.fn.systemlist("git -C " .. buffer_dir .. " rev-parse --show-toplevel")[1]

  local opts = {
    vimgrep_arguments = {
      "rg", "--color=never", "--no-heading", "--with-filename",
      "--line-number", "--column", "--smart-case",
      "-uu", "--glob", "!**/node_modules/**", "--glob", "!**/.git/**",
    },
  }

  if git_root and vim.fn.isdirectory(git_root) ~= 0 then
    opts.cwd = git_root
    opts.prompt_title = "Grep Git Root"
  else
    opts.cwd = buffer_dir
    opts.prompt_title = "Grep Current Dir"
  end

  builtin.live_grep(opts)
end, { desc = "Live Grep" })

