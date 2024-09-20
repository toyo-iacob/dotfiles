-- avoid line swapping when hitting esc + hjkl
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0

-- full width status line (lua-line)
vim.o.laststatus = 3

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.background = "light"

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.opt.swapfile = false

vim.wo.number = true
vim.wo.relativenumber = true
