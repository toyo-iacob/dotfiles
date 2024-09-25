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
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")
			lspconfig.bashls.setup({
				capabilities = capabilities,
			})
			lspconfig.dockerls.setup({
				capabilities = capabilities,
			})
			lspconfig.gopls.setup({
				capabilities = capabilities,
			})
			lspconfig.templ.setup({
				capabilities = capabilities,
			})
			lspconfig.helm_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.spectral.setup({
				capabilities = capabilities,
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.grammarly.setup({
				capabilities = capabilities,
			})
			lspconfig.nginx_language_server.setup({
				capabilities = capabilities,
			})
			lspconfig.pbls.setup({
				capabilities = capabilities,
			})
			lspconfig.sqls.setup({
				capabilities = capabilities,
			})
			lspconfig.terraformls.setup({
				capabilities = capabilities,
			})
			lspconfig.gitlab_ci_ls.setup({
				capabilities = capabilities,
			})
		end,
	},
	{
		"nvimdev/lspsaga.nvim",
		config = function()
			require("lspsaga").setup({
				ui = {
					code_action = "",
				},
			})
			vim.keymap.set("n", "K", ":Lspsaga hover_doc<CR>", { desc = "Signature" })
			vim.keymap.set("n", "<leader>ca", ":Lspsaga code_action<CR>", { desc = "Code action" })
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
	},
}
