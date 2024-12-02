return {
	"saghen/blink.cmp",
	lazy = false,
	version = "v0.*",
	-- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	event = "InsertEnter",

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		highlight = {
			use_nvim_cmp_as_default = false,
		},
		nerd_font_variant = "mono",
		completion = {
			menu = {
				winblend = vim.o.pumblend,
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
			},
		},

		sources = {
			completion = {
				enabled_providers = { "lsp", "path", "snippets", "buffer", "lazydev" },
			},
			providers = {
				lsp = {
					fallback_for = { "lazydev" },
				},
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
				},
			},
		},
	},
	opts_extend = { "sources.completion.enabled_providers" },
}
