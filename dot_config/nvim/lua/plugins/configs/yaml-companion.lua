-- lazy load on YAML
local cfg = require("yaml-companion").setup({
	builtin_matchers = {
		kubernetes = { enabled = true },
		cloud_init = { enabled = false },
	},
	schemas = {
		{
			name = "Kubernetes 1.26.5",
			uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.26.5-standalone-strict/all.json",
		},
	},
	-- @ref: https://www.lazyvim.org/extras/lang/yaml
	lspconfig = {
		settings = {
			redhat = { telemetry = { enabled = false } },
			yaml = {
				keyOrdering = false,
				format = {
					enable = true,
				},
				validate = true,

				-- schemaStore = { -- これを有効にするとtelescope pickerが有効になるが、何でもないyamlで外部通信が発生する(catalogのダウンロード)
				--   enable = true,
				--   url = "https://www.schemastore.org/api/json/catalog.json",
				-- },
				schemaStore = {
					-- Must disable built-in schemaStore support to use
					-- schemas from SchemaStore.nvim plugin
					enable = false,
					-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
					url = "",
				},
				schemas = require("schemastore").yaml.schemas(), -- schemastoreを使うことで何でもないyamlで外部通信が発生しないが, pickerが動かなくなる
			},
		},
	},
})

-- Setup yaml LSP
require("lspconfig")["yamlls"].setup(cfg)
-- require("telescope").load_extension("yaml_schema")
