return {
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-cmdline" },
	{ "hrsh7th/cmp-nvim-lsp-signature-help" },
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
		build = "make install_jsregexp",
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local types = require("cmp.types")
			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end
			local function limit_lsp_types(entry, ctx)
				local kind = entry:get_kind()
				local line = ctx.cursor.line
				local col = ctx.cursor.col
				local char_before_cursor = string.sub(line, col - 1, col - 1)
				local char_after_dot = string.sub(line, col, col)

				if char_before_cursor == "." and char_after_dot:match("[a-zA-Z]") then
					if
						kind == types.lsp.CompletionItemKind.Method
						or kind == types.lsp.CompletionItemKind.Field
						or kind == types.lsp.CompletionItemKind.Property
					then
						return true
					else
						return false
					end
				elseif string.match(line, "^%s+%w+$") then
					if
						kind == types.lsp.CompletionItemKind.Function
						or kind == types.lsp.CompletionItemKind.Variable
					then
						return true
					else
						return false
					end
				end

				return true
			end
			local buffer_option = {
				-- Complete from all visible buffers (splits)
				get_bufnrs = function()
					local bufs = {}
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						bufs[vim.api.nvim_win_get_buf(win)] = true
					end
					return vim.tbl_keys(bufs)
				end,
			}

			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{
						name = "nvim_lsp_signature_help",
						-- priority = 10,
						-- max_item_count = 3,
					},
					{
						name = "copilot",
						priority = 10,
						max_item_count = 3,
					},
					{
						name = "nvim_lsp",
						priority = 9,
						-- Limits LSP results to specific types based on line context (Fields, Methods, Variables)
						entry_filter = limit_lsp_types,
					},
					{
						name = "luasnip",
						priority = 7,
						max_item_count = 5,
					},
					{
						name = "buffer",
						priority = 7,
						keyword_length = 5,
						max_item_count = 10,
						option = buffer_option,
					},
					{ name = "nvim_lua", priority = 5 },
					{ name = "path", priority = 4 },
				}),
				sorting = {
					priority_weight = 2,
					comparators = {
						require("copilot_cmp.comparators").prioritize,

						-- Below is the default comparator list and order for nvim-cmp
						cmp.config.compare.offset,
						-- cmp.config.compare.scopes, --this is commented in nvim-cmp too
						cmp.config.compare.exact,
						cmp.config.compare.score,
						cmp.config.compare.recently_used,
						cmp.config.compare.locality,
						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
			})
			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
			--
			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	},
}
