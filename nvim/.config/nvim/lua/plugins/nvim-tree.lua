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
			-- sync_root_with_cwd = true,
			auto_reload_on_write = true,
			update_focused_file = {
				enable = true,
				update_root = {
					enable = true,
				},
			},
			view = {
				adaptive_size = true,
				centralize_selection = false,
				cursorline = true,
				debounce_delay = 15,
				preserve_window_proportions = false,
				signcolumn = "yes",
			},
			filters = {
				dotfiles = false,
				git_ignored = false,
			},
			renderer = {
				add_trailing = false,
				group_empty = false,
				highlight_git = true,
				full_name = false,
				highlight_opened_files = "icon",
				highlight_modified = "none",
				root_folder_label = ":~:s?$?/..?",
				indent_width = 2,
				indent_markers = {
					enable = true,
					inline_arrows = true,
					icons = {
						corner = "└",
						edge = "│",
						item = "│",
						bottom = "─",
						none = " ",
					},
				},
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
