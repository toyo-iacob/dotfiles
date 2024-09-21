return {
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"BurntSushi/ripgrep",
			"nvim-telescope/telescope-live-grep-args.nvim",
		},
		config = function()
			local lga_actions = require("telescope-live-grep-args.actions")
			require("telescope").setup({
				defaults = {
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
						"--iglob",
						"!.git",
					},
				},
				mapping = {
					i = {
						-- map actions.which_key to <C-h> (default: <C-/>)
						-- actions.which_key shows the mappings for your picker,
						-- e.g. git_{create, delete, ...}_branch for the git_branches picker
						["<C-h>"] = "which_key",
					},
				},
				pickers = {
					find_files = {
						hidden = true,
					},
				},
				extensions = {
					live_grep_args = {
						auto_quoting = true, -- enable/disable auto-quoting
					},
				},
			})
			local builtin = require("telescope.builtin")
			local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
			local find_files = function()
				builtin.find_files {
					find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
					previewer = false
				}
			end

			vim.keymap.set("n", "<leader>ff", find_files, { desc = "Files" })
			vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Old files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Grep" })
			vim.keymap.set("n", "<leader>fz", builtin.current_buffer_fuzzy_find, { desc = "Document fuzzy" })
			-- TODO: how to sort by last accessed here?
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
			vim.keymap.set("n", "<leader>fr", builtin.registers, { desc = "Registers" })
			vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document symbols" })
			-- vim.keymap.set("n", "<leader>fS", builtin.lsp_workspace_symbols, { desc = "Document symbols" })
			vim.keymap.set("n", "<leader>fS", builtin.lsp_dynamic_workspace_symbols, { desc = "Workspace symbols" })

			vim.keymap.set(
				"n",
				"<leader>fc",
				live_grep_args_shortcuts.grep_word_under_cursor,
				{ desc = "Grep word under cursor" }
			)
			vim.keymap.set(
				"v",
				"<leader>f",
				live_grep_args_shortcuts.grep_visual_selection,
				{ desc = "Grep selection" }
			)

			vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Go to definitions" })
			vim.keymap.set("n", "gt", builtin.lsp_type_definitions, { desc = "Go to type definitions" })
			vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "Go to references" })
			vim.keymap.set("n", "gi", builtin.lsp_implementations, { desc = "Go to implementations" })

			require("telescope").load_extension("live_grep_args")
		end,
	},
}
