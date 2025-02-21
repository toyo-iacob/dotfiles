return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		lazy = false,
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- LSPs
					"bash-language-server",
					"dockerfile-language-server",
					"gopls",
					"templ",
					"helm-ls",
					"spectral-language-server",
					"lua-language-server",
					"grammarly-languageserver",
					"nginx-language-server",
					"buf-language-server",
					"sqls",
					"terraform-ls",
					"gitlab-ci-ls",
					"python-lsp-server",
					"typescript-language-server",
					"html-lsp",
					"htmx-lsp",

					-- Linters
					"pylint",
					"eslint_d",
					"shellcheck",
					"jsonlint",
					"yamllint",
					"htmlhint",
					"textlint",
					"codespell",
					"golangci-lint",
					"tflint",
					"sqlfmt",
					"nilaway",

					-- Formatters
					"prettierd",
					"stylua",
					"gofumpt",
					"goimports",
					"gomodifytags",
					"sql-formatter",
					"yamlfmt",
					"shellharden",
					"jq",
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
			lspconfig.buf_ls.setup({
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
			vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
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
			vim.keymap.set("n", "<leader>cd", ":Lspsaga show_buf_diagnostics<CR>", { desc = "Buf diagnostics" })
			vim.keymap.set("n", "go", ":Lspsaga outline<CR>", { desc = "Outline" })
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons",  -- optional
		},
	},
}
