-- avoid line swapping when hitting esc + hjkl
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0

-- full width status line (lua-line)
vim.o.laststatus = 3

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.background = "light"

-- indent
vim.opt.tabstop = 2
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.swapfile = false

vim.wo.number = true
vim.wo.relativenumber = true

-- spelling
vim.opt.spelllang = "en_us"
vim.opt.spell = true

-- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
-- delays and poor user experience
vim.opt.updatetime = 300

-- auto read file if changed in other part
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = { "*" },
})

-- number of context lines to see above and below cursor, ie. center cursor
vim.opt.so = 20
