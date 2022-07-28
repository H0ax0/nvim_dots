local pattern = "[%z\1-\127\194-\244][\128-\191]*"

-- helper function
local posrelat = function(pos, len)
	if pos < 0 then
		pos = len + pos + 1
	end

	return pos
end

local utf8 = {}

-- THE MEAT

-- maps f over s's utf8 characters f can accept args: (visual_index, utf8_character, byte_index)
utf8.map = function(s, f, no_subs)
	local i = 0

	if no_subs then
		for b, e in s:gmatch("()" .. pattern .. "()") do
			i = i + 1
			local c = e - b
			f(i, c, b)
		end
	else
		for b, c in s:gmatch("()(" .. pattern .. ")") do
			i = i + 1
			f(i, c, b)
		end
	end
end

-- THE REST

-- generator for the above -- to iterate over all utf8 chars
utf8.chars = function(s, no_subs)
	return coroutine.wrap(function()
		return utf8.map(s, coroutine.yield, no_subs)
	end)
end

-- returns the number of characters in a UTF-8 string
utf8.len = function(s)
	-- count the number of non-continuing bytes
	return select(2, s:gsub("[^\128-\193]", ""))
end

-- replace all utf8 chars with mapping
utf8.replace = function(s, map)
	return s:gsub(pattern, map)
end

-- reverse a utf8 string
utf8.reverse = function(s)
	-- reverse the individual greater-than-single-byte characters
	s = s:gsub(pattern, function(c)
		return #c > 1 and c:reverse()
	end)

	return s:reverse()
end

-- strip non-ascii characters from a utf8 string
utf8.strip = function(s)
	return s:gsub(pattern, function(c)
		return #c > 1 and ""
	end)
end

-- like string.sub() but i, j are utf8 strings
-- a utf8-safe string.sub()
utf8.sub = function(s, i, j)
	local l = utf8.len(s)

	i = posrelat(i, l)
	j = j and posrelat(j, l) or l

	if i < 1 then
		i = 1
	end
	if j > l then
		j = l
	end

	if i > j then
		return ""
	end

	local diff = j - i
	local iter = utf8.chars(s, true)

	-- advance up to i
	for _ = 1, i - 1 do
		iter()
	end

	local c, b = select(2, iter())

	-- i and j are the same, single-charaacter sub
	if diff == 0 then
		return string.sub(s, b, b + c - 1)
	end

	i = b

	-- advance up to j
	for _ = 1, diff - 1 do
		iter()
	end

	c, b = select(2, iter())

	return string.sub(s, i, b + c - 1)
end

return utf8
