local M = {}

local icons_ok, nwd = pcall(require, "nvim-web-devicons")
if not icons_ok then
	vim.notify("plenary not installed", "error")
	return
end

function M.get_extension(file_name)
	local match = file_name:match("^.+(%..+)$")
	local ext = ""
	if match ~= nil then
		ext = match:sub(2)
	end
	return ext
end

function M.icon(file_name)
	local ext = M.get_extension(file_name)
	return nwd.get_icon(file_name, ext, { default = true })
end

function M.extract_color_and_param(dirty_string)
	if string.match(dirty_string, "Cyan>") then
		return { name = dirty_string:gsub("Cyan>", ""):gsub("<", ""), hl = "Cyan" }
	end
end

function M.starshipfy(project)
	local starship_text = ""
	local the_tab = {}
	local handle = io.popen(
		"STARSHIP_CONFIG="
			.. vim.fn.stdpath("data")
			.. "/segments.toml "
			.. vim.fn.stdpath("data")
			.. "/starship prompt -p "
			.. project
	)
	if handle ~= nil then
		starship_text = handle:read("*a")
		handle:close()
		starship_text = starship_text:gsub("\nGreen❯ ", "")
		starship_text = starship_text:gsub("\n", "")
		starship_text = starship_text:gsub("(.-)%s", "", 1)
		starship_text = starship_text:sub(1, -2)
		starship_text = "{" .. starship_text .. "}"
		the_tab = vim.json.decode(starship_text)
	end
	return the_tab
end

function M.str_sizer(the_str, dsize)
	local utf8 = require("user.utils.utf8")
	local len = utf8.len(the_str)
	if len < dsize then
		for _ = len, dsize, 1 do
			the_str = the_str .. " "
		end
		return the_str
	elseif len > dsize then
		for _ = len, dsize, -1 do
			the_str = utf8.sub(the_str, 1, -2)
		end
		return the_str
	end
	return the_str
end

function M.render_startship_text(fn, short_fn, sc)
	local starship_tbl = M.starshipfy(fn)
	local hl_shortcut_tbl = {
		{ "AlphaCustomHlgreen", 0, 1 },
		{ "AlphaCustomHlblue", 1, #sc + 1 },
		{ "AlphaCustomHlgreen", #sc + 1, #sc + 2 },
	}
	local btn_text = short_fn
	local symbols_str = ""
	local symbols_hl = {}
	local pckg_man = ""
	local extra_cool = ""
	local git_str = ""
	local git_hl = {}
	local link_style = ""

	for k, v in pairs(starship_tbl) do
		if
			k == "cmake"
			or k == "cobol"
			or k == "cristal"
			or k == "daml"
			or k == "dart"
			or k == "deno"
			or k == "elm"
			or k == "erlang"
			or k == "golang"
			or k == "haskell"
			or k == "helm"
			or k == "java"
			or k == "julia"
			or k == "kotlin"
			or k == "lua"
			or k == "nim"
			or k == "nodejs"
			or k == "perl"
			or k == "php"
			or k == "purescript"
			or k == "red"
			or k == "ruby"
			or k == "rust"
			or k == "scala"
			or k == "swift"
			or k == "vagrant"
			or k == "vlang"
			or k == "zig"
		then
			symbols_str = symbols_str .. v.symbol
			link_style = v.style
			table.insert(symbols_hl, { "AlphaCustomHl" .. v.style })
		elseif k == "c" then
			symbols_str = symbols_str .. v.symbol
			link_style = v.style
			table.insert(symbols_hl, { "AlphaCustomHl" .. v.style })
		elseif k == "conda" then
			symbols_str = symbols_str .. v.symbol
			table.insert(symbols_hl, { "AlphaCustomHl" .. v.style })
		elseif k == "docker" then
			symbols_str = symbols_str .. v.symbol
			table.insert(symbols_hl, { "AlphaCustomHl" .. v.style })
			if v.context ~= "" then
				extra_cool = extra_cool .. " dc " .. v.context
			end
			if link_style == "" then
				link_style = v.style
			end
		elseif k == "dotnet" then
			symbols_str = symbols_str .. v.symbol
			table.insert(symbols_hl, { "AlphaCustomHl" .. v.style })
			if v.tfm ~= "" then
				extra_cool = extra_cool .. " .net " .. v.tfm
			end
			link_style = v.style
		elseif k == "elixir" then
			symbols_str = symbols_str .. v.symbol
			table.insert(symbols_hl, { "AlphaCustomHl" .. v.style })
			if v.otp ~= "" then
				extra_cool = extra_cool .. " otp " .. v.otp
			end
			link_style = v.style
		elseif k == "gcloud" then
			symbols_str = symbols_str .. v.symbol
			table.insert(symbols_hl, { "AlphaCustomHl" .. v.style })
			if v.account ~= "" then
				extra_cool = extra_cool .. " gc: " .. v.account
			end
			if v.domain ~= "" then
				extra_cool = extra_cool .. "@" .. v.domain
			end
			if v.region ~= "" then
				extra_cool = extra_cool .. " at " .. v.region
			end
		elseif k == "git_branch" then
			git_str = v.symbol .. v.branch .. " " .. git_str
			table.insert(git_hl, 1, { "AlphaCustomHl" .. v.style, #v.symbol + #v.branch + 1 })
		elseif k == "git_commit" then
			git_str = git_str .. " " .. v.tag .. " " .. v.hash
			table.insert(git_hl, { "AlphaCustomHl" .. v.style, #v.tag + #v.branch + 3 })
		elseif k == "git_metrics" then
			git_str = git_str
		elseif k == "git_status" then
			if v.all_status ~= "" then
				git_str = git_str .. " " .. v.all_status
				table.insert(git_hl, { "AlphaCustomHl" .. v.style, #v.all_status + 2 })
			end
			if v.ahead_behind ~= "" then
				git_str = git_str .. " " .. v.ahead_behind
				table.insert(git_hl, { "AlphaCustomHl" .. v.style, #v.ahead_behind + 2 })
			end
		elseif k == "hg_branch" then
			git_str = git_str .. v.symbol
			if v.branch ~= "" then
				git_str = git_str .. " " .. v.branch
			end
		elseif k == "kubernetes" then
			symbols_str = symbols_str .. v.symbol
			table.insert(symbols_hl, { "AlphaCustomHl" .. v.style })
			if v.context ~= "" then
				extra_cool = extra_cool .. " k8s " .. v.context
			end
			if v.namespace ~= "" then
				extra_cool = extra_cool .. " " .. v.namespace
			end
			if link_style == "" then
				link_style = v.style
			end
		elseif k == "memory_usage" then
			symbols_str = symbols_str
		elseif k == "nix_shell" then
			symbols_str = symbols_str .. v.symbol
			table.insert(symbols_hl, { "AlphaCustomHl" .. v.style })
			if v.state ~= "" then
				extra_cool = extra_cool .. " nix " .. v.state
			end
			if v.name ~= "" then
				extra_cool = extra_cool .. " " .. v.name
			end
			if link_style == "" then
				link_style = v.style
			end
		elseif k == "ocaml" then
			symbols_str = symbols_str .. v.symbol
			table.insert(symbols_hl, { "AlphaCustomHl" .. v.style })
			link_style = v.style
		elseif k == "openstack" then
			symbols_str = symbols_str .. v.symbol
			table.insert(symbols_hl, { "AlphaCustomHl" .. v.style })
			if v.cloud ~= "" then
				extra_cool = extra_cool .. " ostk " .. v.cloud
			end
			if v.project ~= "" then
				extra_cool = extra_cool .. " " .. v.project
			end
		elseif k == "package" then
			pckg_man = pckg_man .. v.symbol
		elseif k == "pulumi" then
			symbols_str = symbols_str .. v.symbol
			table.insert(symbols_hl, { "AlphaCustomHl" .. v.style })
			if v.stack ~= "" then
				extra_cool = extra_cool .. " pulumi " .. v.stack
			end
		elseif k == "python" then
			symbols_str = symbols_str .. v.symbol
			table.insert(symbols_hl, { "AlphaCustomHl" .. v.style })
			link_style = v.style
		elseif k == "raku" then
			symbols_str = symbols_str .. v.symbol
			table.insert(symbols_hl, { "AlphaCustomHl" .. v.style })
			link_style = v.style
		elseif k == "spack" then
			symbols_str = symbols_str .. v.symbol
			table.insert(symbols_hl, { "AlphaCustomHl" .. v.style })
			link_style = v.style
		elseif k == "sudo" then
			symbols_str = symbols_str
		elseif k == "terraform" then
			symbols_str = symbols_str .. v.symbol
			table.insert(symbols_hl, { "AlphaCustomHl" .. v.style })
			if v.workspace ~= "" then
				extra_cool = extra_cool .. " tf " .. v.workspace
			end
			if link_style == "" then
				link_style = v.style
			end
		elseif k == "time" then
			symbols_str = symbols_str
		else
			vim.notify("Unmatched " .. k, "warn")
		end
	end
	--symbols hl
	local symbols_temp = ""
	local utf8 = require("user.utils.utf8")
	local x = 0
	for i = 1, utf8.len(symbols_str), 1 do
		local character = utf8.sub(symbols_str, i, i)
		if i <= #symbols_hl then
			table.insert(
				hl_shortcut_tbl,
				{ unpack(vim.tbl_get(symbols_hl, i), 1), #sc + 4 + x, #sc + 4 + x + #character }
			)
		end
		if i == utf8.len(symbols_str) then
			symbols_temp = symbols_temp .. character
			x = x + #character
		else
			symbols_temp = symbols_temp .. character .. " "
			x = x + #character + 1
		end
	end
	symbols_str = M.str_sizer(symbols_temp, 6)
	--git hl
	git_str = M.str_sizer(git_str, 10)
	local hl_git_pos = #sc + 5 + #symbols_str + #short_fn
	for i = 1, #git_hl, 1 do
		local hl_str, hl_len = unpack(vim.tbl_get(git_hl, i))
		table.insert(hl_shortcut_tbl, { hl_str, hl_git_pos, hl_git_pos + hl_len })
		hl_git_pos = hl_git_pos + hl_len
	end

	btn_text = " " .. symbols_str .. " " .. short_fn .. git_str

	table.insert(
		hl_shortcut_tbl,
		{ "AlphaCustomHl" .. link_style, #sc + 5 + #symbols_str, #sc + 5 + #symbols_str + #short_fn }
	)
	return btn_text, hl_shortcut_tbl
end

return M
