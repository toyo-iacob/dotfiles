return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("nvim-tree").setup({
			disable_netrw = true,
			sync_root_with_cwd = true,
			update_focused_file = {
				enable = true,
				update_root = {
					enable = true,
				},
			},
			filters = {
				git_ignored = false,
			},
		})
	end,
	keys = {
		{
			"<leader>e",
			function()
				require("nvim-tree.api").tree.toggle()
			end,
			desc = "Toggle Nvim Tree",
		},
	},
}
