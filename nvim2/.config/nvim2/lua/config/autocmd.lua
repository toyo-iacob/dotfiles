-- highlight yanked text
vim.cmd [[
	augroup highlight_yank
	autocmd!
	au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Search", timeout=300})
	augroup END
]]

-- Trim whitespace on all file
vim.cmd [[
	augroup trim_whitespace
	autocmd!
	au BufWritePre * %s/\s\+$//e
	augroup END
]]

-- Hide invisible chars in help and telescope
vim.cmd [[
	augroup nolist_by_ft
	autocmd!
  au FileType help setlocal nolist
  au FileType TelescopePrompt setlocal nolist
	augroup END
]]
