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

		require("mason-lspconfig").setup_handlers({
			function(server_name)
				if opts.servers and opts.servers[server_name] then
					opts.servers[server_name].capabilities =
						require("blink.cmp").get_lsp_capabilities(opts.servers[server_name].capabilities)
				end

				lspconfig[server_name].setup({})
			end,
		})
	end,
}
