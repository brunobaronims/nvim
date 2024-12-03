return {
	"williamboman/mason.nvim",
	cmd = "Mason",
	build = ":MasonUpdate",
	opts_extend = { "ensure_installed" },
	opts = {
		ensure_installed = {
			"stylua",
			"shfmt",
			"gopls",
			"gofumpt",
			"html",
			"prettier",
			"biome",
			"tailwindcss-language-server",
		},
	},
}
