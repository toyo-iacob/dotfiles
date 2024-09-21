return {
	{
		"tpope/vim-fugitive"
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signcolumn = false,
				numhl = true,

				current_line_blame = false,
				current_line_blame_opts = {
					delay = 0,
				},
				on_attach = function(bufnr)
					local gitsigns = require('gitsigns')
					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map('n', ']c', function()
						if vim.wo.diff then
							vim.cmd.normal({ ']c', bang = true })
						else
							gitsigns.nav_hunk('next')
						end
					end, { desc = "Next hunk" })

					map('n', '[c', function()
						if vim.wo.diff then
							vim.cmd.normal({ '[c', bang = true })
						else
							gitsigns.nav_hunk('prev')
						end
					end, { desc = "Prev hunk" })

					-- Actions
					map('n', '<leader>gr', gitsigns.reset_hunk, { desc = "Reset Hunk" })
					map('v', '<leader>gr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
						{ desc = "Reset hunk" })
					map('n', '<leader>gR', gitsigns.reset_buffer, { desc = "Reset Buffer" })
					map('n', '<leader>gp', gitsigns.preview_hunk, { desc = "Preview Hunk" })
					map('n', '<leader>gb', function() gitsigns.blame_line { full = true } end, { desc = "Blame Line" })
					map('n', '<leader>gd', gitsigns.diffthis, { desc = "Diff" })
					-- map('n', '<leader>gD', function() gitsigns.diffthis('~') end, { desc = "Diff2" })
					map('n', '<leader>gt', gitsigns.toggle_deleted, { desc = "Toggle Deleted" })
				end
			})
		end
	}
}
