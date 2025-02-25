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
					-- Linters
					"codespell",
					"eslint_d",
					"golangci-lint",
					"htmlhint",
					"jsonlint",
					"nilaway",
					"pylint",
					"shellcheck",
					"sqlfmt",
					"tflint",
					"textlint",
					"yamllint",

					-- Formatters
					"goimports",
					"gofumpt",
					"gomodifytags",
					"jq",
					"prettierd",
					"shellharden",
					"sql-formatter",
					"stylua",
					"yamlfmt",
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
					"bashls",
					"buf_ls",
					"dockerls",
					"gitlab_ci_ls",
					"gopls",
					"grammarly",
					"helm_ls",
					"html",
					"htmx",
					"lua_ls",
					"nginx_language_server",
					"pbls",
					"pylsp",
					"sqls",
					"templ",
					"terraformls",
					"tflint",
					"ts_ls",
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
