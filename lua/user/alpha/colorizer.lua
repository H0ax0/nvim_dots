local M = {}

local function header_chars(headers)
	return headers[math.random(#headers)]
end

function M.header_color(headres)
	local lines = {}
	for i, line_chars in pairs(header_chars(headres)) do
		local hi = "StartLogo" .. i
		local line = {
			type = "text",
			val = line_chars,
			opts = {
				hl = hi,
				shrink_margin = false,
				position = "center",
			},
		}
		table.insert(lines, line)
	end
	local logo = {
		type = "group",
		val = lines,
		opts = { position = "center" },
	}
	return logo
end

return M
