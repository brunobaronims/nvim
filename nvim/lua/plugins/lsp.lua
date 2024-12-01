return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason.nvim",
		{ "williamboman/mason-lspconfig.nvim", config = function() end },
	},
	config = function()
		local lspconfig = require("lspconfig")

		require("mason-lspconfig").setup_handlers({
			function(server_name)
				if server_name == "lua_ls" then
					lspconfig.lua_ls.setup({
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
								runtime = {
									version = "LuaJIT",
									path = vim.split(package.path, ";"),
								},
								workspace = {
									library = vim.api.nvim_get_runtime_file("lua", true),
								},
							},
						},
					})
				else
					lspconfig[server_name].setup({})
				end
			end,
		})
	end,
}
