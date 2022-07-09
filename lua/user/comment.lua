local comment_ok, comment = pcall(require, "Comment")
if not comment_ok then
	vim.notify("comment not installed")
	return
end
comment.setup()
