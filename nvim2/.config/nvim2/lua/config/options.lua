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
vim.opt.spelllang = 'en_us'
vim.opt.spell = true
