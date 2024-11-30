return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason.nvim",
		{ "williamboman/mason-lspconfig.nvim", config = function() end },
	},
	config = function()
		local lspconfig = require("lspconfig")

		-- Automatically setup LSP servers that are installed via mason
		require("mason-lspconfig").setup_handlers({
			function(server_name)
				-- Setup the Lua LSP (sumneko_lua or lua-ls)
				if server_name == "lua_ls" then
					lspconfig.lua_ls.setup({
						settings = {
							Lua = {
								-- Enable diagnostics (for issues like undefined variables)
								diagnostics = {
									globals = { "vim" }, -- Allow the 'vim' global (useful for Neovim configs)
								},
								-- Additional settings for Lua language server
								runtime = {
									version = "LuaJIT", -- Lua runtime version (important for Neovim compatibility)
								},
								workspace = {
									library = vim.api.nvim_get_runtime_file("", true), -- Include Neovim runtime files
								},
								-- Additional LSP configuration settings can go here
							},
						},
					})
				else
					-- Default handler for other LSP servers
					lspconfig[server_name].setup({})
				end
			end,
		})
	end,
}
