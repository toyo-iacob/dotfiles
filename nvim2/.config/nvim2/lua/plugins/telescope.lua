return {
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
			vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Telescope document symbols" })
			-- vim.keymap.set("n", "<leader>fS", builtin.lsp_workspace_symbols, { desc = "Telescope document symbols" })
			vim.keymap.set(
				"n",
				"<leader>fS",
				builtin.lsp_dynamic_workspace_symbols,
				{ desc = "Telescope workspace symbols" }
			)

			require("telescope").load_extension("ui-select")
		end,
	},
}
