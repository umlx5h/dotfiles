local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	formatting = {
		format = function(entry, vim_item)
			-- clangd のcompletion popup (K)の引数表示が邪魔なので一時的に無効にする
			vim_item.menu = nil
			return vim_item
		end,
	},
	completion = {
		completeopt = "menu,menuone,noinsert", -- 最初の候補を自動的に選択
	},
	-- Goなどで勝手に補完が選択されるので、されないようにする
	-- :h cmp-faq
	-- > Why does cmp automatically select a particular item?
	-- > How to disable the preselect feature?
	preselect = cmp.PreselectMode.None,
	-- mapping = cmp.mapping.preset.insert({
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<Up>"] = cmp.mapping.select_prev_item(),
		["<Down>"] = cmp.mapping.select_next_item(),
		["<PageUp>"] = cmp.mapping.select_prev_item({ count = 11 }),
		["<PageDown>"] = cmp.mapping.select_next_item({ count = 11 }),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),

		["<C-Space>"] = cmp.mapping.complete(),
		["<C-g>"] = cmp.mapping.abort(), -- C-eだとemacsキーバインドと被るのでemacs風に
		["<CR>"] = cmp.mapping.confirm({ select = true }),

		-- luasnip
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				-- cmp.select_next_item()
				-- TABで確定
				cmp.confirm({ select = true })
			elseif require("luasnip").expand_or_jumpable() then
				vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif require("luasnip").jumpable(-1) then
				vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	},
	sources = cmp.config.sources({
		{
			name = "lazydev",
			-- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
			group_index = 0,
		},
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "nvim_lua" },
		{ name = "path" },
		{ name = "nvim_lsp_signature_help" },
	}),
})
