return {
	"gbprod/yanky.nvim",
	dependencies = {
		{ "kkharji/sqlite.lua" },
	},
	opts = {
		ring = { storage = "sqlite" },
	},
	keys = {
		{
			"<leader>P",
			function()
				require("telescope").extensions.yank_history.yank_history({})
			end,
			desc = "Open Yank History",
		},
		{
			"y",
			"<Plug>(YankyYank)",
			mode = { "n", "x" },
			desc = "Yank text",
		},
		{
			"p",
			"<Plug>(YankyPutAfter)",
			mode = { "n", "x" },
			desc = "Put yanked text after cursor",
		},
		{
			"P",
			"<Plug>(YankyPutBefore)",
			mode = { "n", "x" },
			desc = "Put yanked text before cursor",
		},
	},
}
