-- Select all
vim.keymap.set("n", "<leader>v", "gg<S-v>G", { desc = "Select all" })

-- Keep window centered when going up/down
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste without overwriting register
vim.keymap.set("v", "p", '"_dP')

-- Copy text to " register
vim.keymap.set("n", "<leader>y", '"+y', { desc = 'Yank into "' })
vim.keymap.set("v", "<leader>y", '"+y', { desc = 'Yank into "' })

-- Delete text to " register
vim.keymap.set("n", "<leader>d", '"_d', { desc = 'Delete into "' })
vim.keymap.set("v", "<leader>d", '"_d', { desc = 'Delete into "' })

-- Past text from " register
vim.keymap.set("n", "<leader>p", '"+p', { desc = 'Paste from "' })
vim.keymap.set("v", "<leader>p", '"+p', { desc = 'Paste from "' })

-- Replace word under cursor across entire buffer
vim.keymap.set(
	"n",
	"<leader>r",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word under cursor" }
)

-- Move block
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Block Down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Block Up" })

-- Search for highlighted text in buffer
vim.keymap.set("v", "//", 'y/<C-R>"<CR>', { desc = "Search for selection" })

-- Close buffer
vim.keymap.set("n", "<leader>w", ":bprevious <bar> bdelete #<CR>", { desc = "Delete buffer" })
