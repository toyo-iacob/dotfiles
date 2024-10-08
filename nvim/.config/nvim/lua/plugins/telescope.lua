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
			"folke/todo-comments.nvim",
		},
		config = function()
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
					layout_strategy = "vertical",
					layout_config = {
						preview_height = 0.65,
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
						find_command = { "rg", "--files", "--iglob", "!.git", "--hidden" },
						hidden = true,
					},
					buffers = {
						initial_mode = "normal",
						sort_lastused = true,
						sort_mru = true,
						mappings = {
							n = {
								["x"] = "delete_buffer",
							},
						},
					},
					lsp_document_symbols = {
						initial_mode = "insert",
						fname_width = 0.4,
						symbol_width = 0.2,
						symbol_type_width = 0.1,
						path_display = { "smart" },
					},
					lsp_dynamic_workspace_symbols = {
						initial_mode = "insert",
						fname_width = 0.4,
						symbol_width = 0.2,
						symbol_type_width = 0.1,
						path_display = { "smart" },
					},
					lsp_definitions = {
						initial_mode = "normal",
						fname_width = 0.4,
						symbol_width = 0.2,
						symbol_type_width = 0.1,
						path_display = { "smart" },
					},
					lsp_type_definitions = {
						initial_mode = "normal",
						fname_width = 0.4,
						symbol_width = 0.2,
						symbol_type_width = 0.1,
						path_display = { "smart" },
					},
					lsp_references = {
						initial_mode = "normal",
						fname_width = 0.4,
						symbol_width = 0.2,
						symbol_type_width = 0.1,
						path_display = { "smart" },
						include_declaration = false,
					},
					lsp_implementations = {
						initial_mode = "normal",
						fname_width = 0.4,
						symbol_width = 0.2,
						symbol_type_width = 0.1,
						path_display = { "smart" },
					},
				},
				extensions = {
					live_grep_args = {
						auto_quoting = true, -- enable/disable auto-quoting
					},
				},
			})
			local builtin = require("telescope.builtin")
			local live_grep_args = require("telescope").load_extension("live_grep_args")
			local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")

			local grepOpts = {
				initial_mode = "normal",
			}
			local grep_word_under_cursor = function()
				live_grep_args_shortcuts.grep_word_under_cursor(grepOpts)
			end
			local grep_visual_selection = function()
				live_grep_args_shortcuts.grep_visual_selection(grepOpts)
			end

			-- resume
			vim.keymap.set("n", "<leader>fp", builtin.resume, { desc = "Previous telescope picker" })

			-- files
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Files" })
			vim.keymap.set("n", "<leader>fm", builtin.git_status, { desc = "Modified files" })
			vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Old files" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })

			-- grep
			vim.keymap.set("n", "<leader>fg", live_grep_args.live_grep_args, { desc = "Grep" })
			vim.keymap.set("n", "<leader>fz", builtin.current_buffer_fuzzy_find, { desc = "Document fuzzy" })
			vim.keymap.set("n", "<leader>fc", grep_word_under_cursor, { desc = "Grep word under cursor" })
			vim.keymap.set("v", "<leader>f", grep_visual_selection, { desc = "Grep selection" })

			-- lsp
			vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document symbols" })
			vim.keymap.set("n", "<leader>fS", builtin.lsp_dynamic_workspace_symbols, { desc = "Workspace symbols" })

			vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Go to definitions" })
			vim.keymap.set("n", "gt", builtin.lsp_type_definitions, { desc = "Go to type definitions" })
			vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "Go to references" })
			vim.keymap.set("n", "gi", builtin.lsp_implementations, { desc = "Go to implementations" })

			-- other
			vim.keymap.set("n", "<leader>fr", builtin.registers, { desc = "Registers" })

			vim.keymap.set("n", "<leader>ft", ":TodoTelescope<CR>", { desc = "TODO's" })
		end,
	},
}
