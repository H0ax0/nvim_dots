local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	vim.notify("cmp plugin not found", "warn")
	return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	vim.notify("luasnip plugin not found", "info")
	return
end

require("luasnip/loaders/from_vscode").lazy_load({
	paths = { vim.fn.stdpath("data") .. "/site/pack/packer/start/friendly-snippets/" },
})

local check_backspace = function()
	local c = vim.api.nvim_win_get_cursor(0)
	local line, col = unpack(c)
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local lspkind_status_ok, lspkind = pcall(require, "lspkind")
if not lspkind_status_ok then
	vim.notify("lspkind plugin not found", "info")
	return
end

local source_mapping = {
	buffer = "[Buffer]",
	nvim_lsp = "[LSP]",
	nvim_lua = "[Lua]",
	cmp_tabnine = "[TN]",
	cmp_clippy = "[CLIPPY]",
	luasnip = "[SN]",
	path = "[PH]",
	emoji = "[EM]",
}

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = {
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		-- Accept currently selected item. If none selected, `select` first item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expandable() then
				luasnip.expand()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif check_backspace() then
				fallback()
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
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			vim_item.kind = lspkind.presets.default[vim_item.kind]
			local menu = source_mapping[entry.source.name]

			if entry.source.name == "cmp_tabnine" then
				if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
					menu = entry.completion_item.data.detail .. menu
				end
				vim_item.kind = ""
				vim_item.kind_hl_group = "CmpItemKindTabnine"
			end

			if entry.source.name == "copilot" then
				vim_item.kind = ""
				vim_item.kind_hl_group = "CmpItemKindCopilot"
			end

			if entry.source.name == "cmp_clippy" then
				vim_item.kind = ""
				vim_item.kind_hl_group = "CmpItemKindClippy"
			end

			if entry.source.name == "emoji" then
				vim_item.kind = "ﲃ"
				vim_item.kind_hl_group = "CmpItemKindEmoji"
			end

			if entry.source.name == "crates" then
				vim_item.kind = ""
				vim_item.kind_hl_group = "CmpItemKindCrate"
			end
			vim_item.menu = menu
			return vim_item
		end,
	},
	sources = {
		{ name = "crates", group_index = 1 },
		{ name = "nvim_lsp", group_index = 2 },
		{ name = "cmp_tabnine", group_index = 2 },
		{
			name = "cmp_clippy",
			group_index = 2,
			option = {
				model = "flax-community/gpt-neo-125M-code-clippy-dedup",
				key = "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",
			},
		},
		{ name = "nvim_lua", group_index = 2 },
		{ name = "copilot", group_index = 2 },
		{ name = "luasnip", group_index = 2 },
		{ name = "buffer", group_index = 2 },
		{ name = "emoji", group_index = 2 },
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	window = {
		documentation = {
			border = "rounded",
			winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
		},
		completion = {
			border = "rounded",
			winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
		},
	},
	experimental = {
		ghost_text = true,
	},
})
