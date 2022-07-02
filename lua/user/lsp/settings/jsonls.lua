local schemastore_ok, schemastore = pcall(require, "schemastore")
if not schemastore_ok then
	vim.notify("schemastore not installed")
	return {}
end
return {
	settings = {
		json = {
			schemas = schemastore.json.schemas(),
			validate = { enable = true },
		},
	},
}
