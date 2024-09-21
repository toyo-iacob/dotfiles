return {
	'akinsho/toggleterm.nvim',
	version = "*",
	config = function()
		require("gitsigns").setup()

		local Terminal = require('toggleterm.terminal').Terminal
		local lazygit  = Terminal:new({
			cmd = "lazygit",
			dir = "git_dir",
			hidden = true,
			direction = "float",
			float_opts = {
				border = "double",
			},
			-- function to run on opening the terminal
			on_open = function(term)
				vim.cmd("startinsert!")
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>",
					{ noremap = true, silent = true, desc = "Close" })
			end,
			-- function to run on closing the terminal
			on_close = function(term)
				vim.cmd("startinsert!")
			end,
		})

		function _lazygit_toggle()
			lazygit:toggle()
		end

		vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>lua _lazygit_toggle()<CR>",
			{ noremap = true, silent = true, desc = "Lazygit" })
	end
}
