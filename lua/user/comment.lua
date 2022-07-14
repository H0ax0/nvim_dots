local comment_ok, comment = pcall(require, "Comment")
if not comment_ok then
	vim.notify("comment not installed", "info")
	return
end

local ts_context_commentstring_ok, ts_context_commentstring = pcall(require, "ts_context_commentstring")
if not ts_context_commentstring_ok then
	vim.notify("ts_context_commentstring not installed", "info")
	comment.setup()
else
	comment.setup({
		pre_hook = function(ctx)
			local U = require("Comment.utils")

			local location = nil
			if ctx.ctype == U.ctype.block then
				location = ts_context_commentstring.utils.get_cursor_location()
			elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
				location = ts_context_commentstring.utils.get_visual_start_location()
			end

			return ts_context_commentstring.internal.calculate_commentstring({
				key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
				location = location,
			})
		end,
	})
end
