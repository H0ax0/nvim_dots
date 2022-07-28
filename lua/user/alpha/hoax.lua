local path_ok, plenary_path = pcall(require, "plenary.path")
if not path_ok then
	return
end

local project_ok, project = pcall(require, "project_nvim")
if not project_ok then
	vim.notify("project_nvim not installed", "info")
	return
end

local dashboard = require("alpha.themes.dashboard")

local U = require("user.utils.utils")
local function file_button(fn, sc, short_fn, keybind_opts)
	local btn_text, btn_hl = U.render_startship_text(fn, short_fn, sc)
	local sc_ = sc:gsub("%s", "")

	local opts = {
		position = "center",
		shortcut = "[" .. sc .. "] ",
		cursor = 1,
		-- width = 50,
		align_shortcut = "rigth",
		width = 55,
		hl_shortcut = btn_hl,
		shrink_margin = false,
	}
        keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
        opts.keymap = { "n", sc_, ":cd " .. fn .."<CR> :NvimTreeOpen <CR>", keybind_opts }

	local function on_press()
		local key = vim.api.nvim_replace_termcodes(sc_ .. "<Ignore>", true, false, true)
		vim.api.nvim_feedkeys(key, "t", false)
	end

	return {
		type = "button",
		val = btn_text,
		on_press = on_press,
		opts = opts,
	}
end

local function mru()
	local target_width = 30

	local tbl = {}
	for i, fn in ipairs(project.get_recent_projects()) do
	if i >= 8 then
		goto projects_end
	end
		local short_fn = vim.fn.fnamemodify(fn, ":~")

		if #short_fn > target_width then
			short_fn = plenary_path.new(short_fn):shorten(1, { -2, -1 })
			if #short_fn > target_width then
				short_fn = plenary_path.new(short_fn):shorten(1, { -1 })
			end
		end
		for _ = #short_fn, target_width, 1 do
			short_fn = short_fn .. " "
		end

		local shortcut = tostring(i)
		local file_button_el = file_button(fn, shortcut, short_fn)
		tbl[i] = file_button_el
	::projects_end::
	end
	return {
		type = "group",
		val = tbl,
		opts = {},
		position = "center",
	}
end

local default_header = {
	type = "text",
	val = {
		[[     *           MMM88&&&&&&&&		]],
		[[                 MMM88&&&&&&&&		]],
		[[                 'MMM88&&&&&&'		]],
		[[                  'MMM8&&&'      *		]],
		[[          |\___/|				]],
		[[          )     (             .              ']],
		[[         =\     /=				]],
		[[           )===(       *			]],
		[[          /     \				]],
		[[          |     |				]],
		[[         /       \				]],
		[[         \       /				]],
		[[  _/\_/\_/\__  _/_/\_/\_/\_/\_/\_/\_/\_/\_/\_ ]],
		[[  |  |  |  |( (  |  |  |  |  |  |  |  |  |  |	]],
		[[  |  |  |  | ) ) |  |  |  |  |  |  |  |  |  | ]],
		[[  |  |  |  |(_(  |  |  |  |  |  |  |  |  |  | ]],
	},
	opts = {
		position = "center",
		hl = "AlphaCustomHlwhite",
		-- wrap = "overflow";
	},
}

local section_mru = {
	type = "group",
	val = {
		{
			type = "text",
			val = "Projects",
			opts = {
				hl = "SpecialComment",
				shrink_margin = false,
				position = "center",
			},
		},
		{ type = "padding", val = 1 },
		{
			type = "group",
			val = function()
				return { mru() }
			end,
			opts = { shrink_margin = false },
			position = "center",
		},
	},
	position = "center",
}

local buttons = {
	type = "group",
	val = {
		{ type = "text", val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
		{ type = "padding", val = 1 },
		dashboard.button("t", "侮 Open Tree", ":NvimTreeOpen <CR>"),
		dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
		dashboard.button("p", "  Find project", ":lua require('telescope').extensions.projects.projects()<CR>"),
		dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
		dashboard.button("c", "  Config", ":cd ~/.config/nvim/<CR> :NvimTreeOpen <CR>"),
		dashboard.button("u", "  Update", ":PackerSync<CR>"),
		dashboard.button("q", "  Quit", ":qa<CR>"),
	},
	position = "center",
}

local config = {
	layout = {
		{ type = "padding", val = 1 },
		default_header,
		{ type = "padding", val = 1 },
		buttons,
		{ type = "padding", val = 1 },
		section_mru,
	},
	opts = {
		margin = 5,
		setup = function()
			vim.cmd([[
            autocmd alpha_temp DirChanged * lua require('alpha').redraw()
            ]])
		end,
	},
}

return {
	config = config,
}
