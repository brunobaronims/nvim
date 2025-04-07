return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason.nvim",
		{ "williamboman/mason-lspconfig.nvim", opts = {} },
	},
	opts = {
		servers = {
			lua_ls = {},
		},
	},
	config = function(_, opts)
		local lspconfig = require("lspconfig")

		require("mason").setup()
		require("mason-lspconfig").setup()

		require("mason-lspconfig").setup_handlers({
			function(server_name)
				lspconfig[server_name].setup({})
			end,
		})
	end,
}
