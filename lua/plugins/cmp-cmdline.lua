return {
        "hrsh7th/cmp-cmdline",
        version = false,
        event = "CmdLineEnter",
        dependencies = {
                "hrsh7th/cmp-buffer",
        },
        config = function()
                local cmp = require("cmp")

                cmp.setup.cmdline({ "/", "?" }, {
                        mapping = cmp.mapping.preset.cmdline(),
                        sources = {
                                { name = "buffer" },
                        },
                })

                cmp.setup.cmdline(":", {
                        mapping = cmp.mapping.preset.cmdline(),
                        sources = cmp.config.sources({
                                { name = "path" },
                        }, {
                                { name = "cmdline" },
                        }),
                })
        end,
}
