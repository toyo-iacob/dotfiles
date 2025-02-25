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
					-- "bash-language-server",
					-- "dockerfile-language-server",
					-- "gopls",
					-- "templ",
					-- "helm-ls",
					-- "spectral-language-server",
					-- "lua-language-server",
					-- "grammarly-languageserver",
					-- "nginx-language-server",
					-- "buf-language-server",
					-- "sqls",
					-- "terraform-ls",
					-- "gitlab-ci-ls",
					-- "python-lsp-server",
					-- "typescript-language-server",
					-- "html-lsp",
					-- "htmx-lsp",

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
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"tflint",
					"helm_ls",
					"bashls",
					"buf_ls",
					"templ",
					"gopls",
					"htmx",
					"dockerls",
					"spectral",
					"lua_ls",
					"grammarly",
					"nginx_language_server",
					"sqls",
					"terraformls",
					"gitlab_ci_ls",
					"pylsp",
					"ts_ls",
					"html",
					"pbls",
				},
				automatic_installation = true,
			})

			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			require("mason-lspconfig").setup_handlers({
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end,
			})

			lspconfig.gopls.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
					buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

					-- Auto-format and organize imports on save
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ async = false })
							vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
						end,
					})
				end,
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
