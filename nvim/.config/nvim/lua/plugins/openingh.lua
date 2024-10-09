return {
	"almo7aya/openingh.nvim",
	config = function()
		require("openingh").setup()
		vim.keymap.set("n", "<Leader>gr", ":OpenInGHRepo <CR>", { desc = "Open in Github Repo" })
		vim.keymap.set("n", "<Leader>gf", ":OpenInGHFile <CR>", { desc = "Open in Github File" })
		vim.keymap.set("n", "<Leader>gl", ":OpenInGHFileLines <CR>", { desc = "Open in Github Line" })
	end,
}
