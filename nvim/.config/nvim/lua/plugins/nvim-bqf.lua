return {
	-- Load nvim-bqf only for the 'qf' filetype
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
	},

	-- Optional: fzf plugin with installation command
	{
		"junegunn/fzf",
		build = function()
			vim.fn["fzf#install"]()
		end,
		lazy = false, -- You can make it lazy load if you want, but since it installs something, it's better to avoid that
	},
}
