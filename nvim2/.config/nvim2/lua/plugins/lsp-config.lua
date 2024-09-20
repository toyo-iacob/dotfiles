return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls",
					"dockerls",
					"gopls",
					"templ",
					"helm_ls",
					"spectral",
					"lua_ls",
					"grammarly",
					"nginx_language_server",
					"pbls",
					"sqls",
					"terraformls",
					"gitlab_ci_ls",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			-- local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")
			lspconfig.bashls.setup({
				-- capabilities = capabilities,
			})
			lspconfig.dockerls.setup({
				-- capabilities = capabilities,
			})
			lspconfig.gopls.setup({
				-- capabilities = capabilities,
			})
			lspconfig.templ.setup({
				-- capabilities = capabilities,
			})
			lspconfig.helm_ls.setup({
				-- capabilities = capabilities,
			})
			lspconfig.spectral.setup({
				-- capabilities = capabilities,
			})
			lspconfig.lua_ls.setup({
				-- capabilities = capabilities,
			})
			lspconfig.grammarly.setup({
				-- capabilities = capabilities,
			})
			lspconfig.nginx_language_server.setup({
				-- capabilities = capabilities,
			})
			lspconfig.pbls.setup({
				-- capabilities = capabilities,
			})
			lspconfig.sqls.setup({
				-- capabilities = capabilities,
			})
			lspconfig.terraformls.setup({
				-- capabilities = capabilities,
			})
			lspconfig.gitlab_ci_ls.setup({
				-- capabilities = capabilities,
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "gr", vim.lsp.buf.implementation, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
