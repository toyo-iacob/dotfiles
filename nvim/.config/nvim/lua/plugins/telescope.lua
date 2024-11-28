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
			"nvim-telescope/telescope-project.nvim",
			"folke/todo-comments.nvim",
		},
		config = function()
			local project_actions = require("telescope._extensions.project.actions")
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
						sort_lastused = true,
						sort_mru = true,
						mappings = {
							n = {
								["x"] = "delete_buffer",
							},
						},
					},
					lsp_document_symbols = {
						fname_width = 0.4,
						symbol_width = 0.2,
						symbol_type_width = 0.1,
						path_display = { "smart" },
					},
					lsp_dynamic_workspace_symbols = {
						fname_width = 0.4,
						symbol_width = 0.2,
						symbol_type_width = 0.1,
						path_display = { "smart" },
					},
					lsp_definitions = {
						fname_width = 0.4,
						symbol_width = 0.2,
						symbol_type_width = 0.1,
						path_display = { "smart" },
					},
					lsp_type_definitions = {
						fname_width = 0.4,
						symbol_width = 0.2,
						symbol_type_width = 0.1,
						path_display = { "smart" },
					},
					lsp_references = {
						fname_width = 0.4,
						symbol_width = 0.2,
						symbol_type_width = 0.1,
						path_display = { "smart" },
						include_declaration = false,
					},
					lsp_implementations = {
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
					project = {
						sync_with_nvim_tree = true, -- default false
						mappings = {
							n = {
								["d"] = project_actions.delete_project,
								["r"] = project_actions.rename_project,
								-- ["c"] = project_actions.add_project,
								["c"] = project_actions.add_project_cwd,
								["f"] = project_actions.find_project_files,
								["b"] = project_actions.browse_project_files,
								["s"] = project_actions.search_in_project_files,
								["R"] = project_actions.recent_project_files,
								["w"] = project_actions.change_working_directory,
								["o"] = project_actions.next_cd_scope,
							},
							i = {
								["<c-d>"] = project_actions.delete_project,
								["<c-v>"] = project_actions.rename_project,
								-- ["<c-a>"] = project_actions.add_project,
								["<c-a>"] = project_actions.add_project_cwd,
								["<c-f>"] = project_actions.find_project_files,
								["<c-b>"] = project_actions.browse_project_files,
								["<c-s>"] = project_actions.search_in_project_files,
								["<c-r>"] = project_actions.recent_project_files,
								["<c-l>"] = project_actions.change_working_directory,
								["<c-o>"] = project_actions.next_cd_scope,
								["<c-w>"] = project_actions.change_workspace,
							},
						},
					},
				},
			})
			local builtin = require("telescope.builtin")
			local live_grep_args = require("telescope").load_extension("live_grep_args")
			local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
			local project = require("telescope").load_extension("project")

			-- resume
			vim.keymap.set("n", "<leader><leader>", builtin.resume, { desc = "Previous telescope picker" })

			-- files
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Files" })
			vim.keymap.set("n", "<leader>fm", builtin.git_status, { desc = "Modified files" })
			vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Old files" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })

			-- grep
			vim.keymap.set("n", "<leader>fg", live_grep_args.live_grep_args, { desc = "Grep" })
			vim.keymap.set("n", "<leader>fz", builtin.current_buffer_fuzzy_find, { desc = "Document fuzzy" })
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

			-- lsp
			vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document symbols" })
			vim.keymap.set("n", "<leader>fS", builtin.lsp_dynamic_workspace_symbols, { desc = "Workspace symbols" })

			vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Go to definitions" })
			vim.keymap.set("n", "gt", builtin.lsp_type_definitions, { desc = "Go to type definitions" })
			vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "Go to references" })
			vim.keymap.set("n", "gi", builtin.lsp_implementations, { desc = "Go to implementations" })

			-- projects
			vim.keymap.set("n", "<leader>fp", project.project, { desc = "Projects" })

			-- other
			vim.keymap.set("n", "<leader>fr", builtin.registers, { desc = "Registers" })

			vim.keymap.set("n", "<leader>ft", ":TodoTelescope<CR>", { desc = "TODO's" })
		end,
	},
}
