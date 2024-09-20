return {
  "nvim-telescope/telescope.nvim",
  config = function()
    vim.cmd("autocmd User TelescopePreviewerLoaded setlocal number")
  end,
}
