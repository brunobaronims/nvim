return {
	"mason-org/mason-lspconfig.nvim",
	dependencies = { "mason.nvim", "neovim/nvim-lspconfig" },
	config = function()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"gopls",
			},
		})
	end,
}
