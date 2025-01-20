return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	-- This will provide type hinting with LuaLS
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		-- Define your formatters
		formatters_by_ft = {
			awk = { "awk" },
			bash = { "shellcheck" },
			buf = { "buf" },
			lua = { "stylua" },
			go = { "gofumpt", "goimports", "gomodifytags", "gotmpl" },
			json = { "jq" },
			templ = { "templ" },
			yaml = { "yamlfmt" },
			sql = { "sql-formatter" },
			-- Use the "*" filetype to run formatters on all filetypes.
			-- Use the "_" filetype to run formatters on filetypes that don't
			-- have other formatters configured.
			["_"] = { "codespell", "trim_whitespace" },
		},
		-- Set default options
		default_format_opts = {
			lsp_format = "fallback",
		},
		-- Customize formatters
		formatters = {
			shfmt = {
				prepend_args = { "-i", "2" },
			},
			gofumpt = {
				args = { "-extra" },
			},
		},
	},
	config = function()
		require("conform").setup({
			format_on_save = function(bufnr)
				-- Disable with a global variable
				if vim.g.disable_autoformat then
					return
				end
				return { timeout_ms = 1000, lsp_format = "fallback" }
			end,
		})

		vim.keymap.set("n", "<leader>cf", function()
			require("conform").format({ async = true, lsp_fallback = true })
		end, { desc = "Format buf" })

		-- Key mapping for FormatToggle
		vim.keymap.set("n", "<leader>cc", ":FormatOnSaveToggle<CR>", { desc = "Toggle Format on Save" })

		vim.api.nvim_create_user_command("FormatOnSaveToggle", function(args)
			if vim.g.disable_autoformat then
				-- FormatDisable! will disable formatting just for this buffer
				vim.g.disable_autoformat = false
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Toggle autoformat-on-save",
		})
	end,
}
