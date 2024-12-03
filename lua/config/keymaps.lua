local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "<C-a>", "gg<S-v>G", { desc = "Select All" })

keymap.set("n", "s", "")

keymap.set("n", "ss", ":split<Return>", vim.tbl_extend("force", opts, { desc = "Split Window Horizontally" }))
keymap.set("n", "sv", ":vsplit<Return>", vim.tbl_extend("force", opts, { desc = "Split Window Vertically" }))

keymap.set("n", "sh", "<C-w>h", vim.tbl_extend("force", opts, { desc = "Jump To Left Window" }))
keymap.set("n", "sk", "<C-w>k", vim.tbl_extend("force", opts, { desc = "Jump To Top Window" }))
keymap.set("n", "sj", "<C-w>j", vim.tbl_extend("force", opts, { desc = "Jump To Bottom Window" }))
keymap.set("n", "sl", "<C-w>l", vim.tbl_extend("force", opts, { desc = "Jump To Right Window" }))

keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window" })
keymap.set("n", "<leader>wo", "<C-w>o", { desc = "Delete Other Windows" })

keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous Buffer" })
keymap.set("n", "<leader>bd", function()
	Snacks.bufdelete()
end, { desc = "Delete Buffer" })
keymap.set("n", "<leader>bo", function()
	Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })

vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
