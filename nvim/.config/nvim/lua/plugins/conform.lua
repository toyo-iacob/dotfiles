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
			go = { "gofumpt", "goimports", "gomodifytags" },
			json = { "jq" },
			templ = { "templ" },
			yaml = { "yamlfmt" },
			sql = { "sql-formatter" },
			-- Use the "*" filetype to run formatters on all filetypes.
			["*"] = { "codespell" },
			-- Use the "_" filetype to run formatters on filetypes that don't
			-- have other formatters configured.
			["_"] = { "trim_whitespace" },
		},
		-- Set default options
		default_format_opts = {
			lsp_format = "fallback",
		},
		-- Set up format-on-save
		format_on_save = {
			-- I recommend these options. See :help conform.format for details.
			lsp_format = "fallback",
			timeout_ms = 1000,
		}, -- Customize formatters
		formatters = {
			shfmt = {
				prepend_args = { "-i", "2" },
			},
			gofumpt = {
				args = { "-extra" },
			},
		},
	},
}
