return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		build = ":Copilot auth",
		opts = {
			suggestion = { enabled = false },
			panel = {
				enabled = false,
				auto_refresh = true,
			},
			filetypes = {
				markdown = true,
				help = true,
			},
		},
		config = function()
			require("copilot").setup()

			-- Accept the current suggestion from the panel
			vim.keymap.set("i", "<C-l>", function()
				require("copilot.panel").accept()
			end, { silent = true, desc = "Accept Copilot panel suggestion" })

			-- Jump to the next suggestion in the panel
			vim.keymap.set("i", "<C-j>", function()
				require("copilot.panel").jump_next()
			end, { silent = true, desc = "Next Copilot panel suggestion" })

			-- Jump to the previous suggestion in the panel
			vim.keymap.set("i", "<C-k>", function()
				require("copilot.panel").jump_prev()
			end, { silent = true, desc = "Previous Copilot panel suggestion" })

			vim.keymap.set("i", "<C-p>", function()
				local curr_win = vim.api.nvim_get_current_win()
				require("copilot.panel").open({ position = "bottom", ratio = 0.4 })
				vim.api.nvim_set_current_win(curr_win)
				vim.schedule(function()
					vim.cmd("startinsert!")
				end)
			end, { silent = true, desc = "Open Copilot panel without leaving insert mode" }) -- Refresh the panel manually
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		config = function()
			require("copilot_cmp").setup()
		end,
	},
}
