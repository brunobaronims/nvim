return {
	"mason-org/mason.nvim",
	cmd = "Mason",
	build = ":MasonUpdate",
	opts = {},
	   config = function()
		require("mason").setup()
	   end,
}
