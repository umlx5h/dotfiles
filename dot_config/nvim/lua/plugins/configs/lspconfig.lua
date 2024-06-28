-------------------------------------- keybinding -----------------------------------

-- @see https://github.com/neovim/nvim-lspconfig#suggested-configuration

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<leader>fd", vim.diagnostic.open_float, { desc = "Floating diagnostic" })
-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" }) -- defined in nap.lua
-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "LSP diagnostics loclist" })
vim.keymap.set("n", "<leader>Q", vim.diagnostic.setqflist, { desc = "LSP diagnostics qflist" })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		-- Disable for nvim-cmp-lsp
		-- > As these candidates are sent on each request, adding these capabilities will break the built-in omnifunc support for neovim's language server client
		-- vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		local map = function(mode, keys, func, desc)
			vim.keymap.set(mode, keys, func, { buffer = ev.buf, desc = desc })
		end

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		map("n", "gD", vim.lsp.buf.declaration, "LSP declaration")
		map("n", "gd", require("telescope.builtin").lsp_definitions, "LSP definition")
		map("n", "gI", require("telescope.builtin").lsp_implementations, "LSP implementation") -- giだと標準のと被る
		map("n", "gy", require("telescope.builtin").lsp_type_definitions, "LSP type definition")
		map("n", "gr", require("telescope.builtin").lsp_references, "LSP references")
		map("n", "K", vim.lsp.buf.hover, "LSP hover")
		map("n", "gK", vim.lsp.buf.signature_help, "LSP signature help")
		vim.keymap.set("n", "g]", "<C-w>}", { remap = true, buffer = ev.buf, desc = "LSP signature preview" })

		map("i", "<C-k>", vim.lsp.buf.signature_help, "LSP signature help")
		-- remap Enter digraph
		map("i", "<C-x><C-k>", "<C-k>", "Insert digraph")

		map("n", "<leader>cr", vim.lsp.buf.rename, "LSP rename")
		map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "LSP code action")
		map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "LSP add workspace")
		map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "LSP remove workspace")
		map("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, "LSP list workspace")
	end,
})

-------------------------------------- LSP setup -----------------------------------

-- Setup neovim lua configuration
-- TODO: lazy load only for lua
require("neodev").setup({})

-- スニペットなどの追加サポート設定
-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
-- @see https://github.com/hrsh7th/cmp-nvim-lsp
-- @see https://github.com/neovim/nvim-lspconfig/wiki/Snippets
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Setup language servers.
local lspconfig = require("lspconfig")

-- Lua
lspconfig.lua_ls.setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					[vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
				},
			},
		},
	},
})

-- Go
lspconfig.gopls.setup({
	capabilities = capabilities,
	settings = {
		-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
		gopls = {
			completeUnimported = true,
			-- usePlaceholders = true,
			-- analyses = {
			-- 	unusedparams = true,
			-- },
		},
	},
})

-- Ansible
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/ansiblels.lua
lspconfig.ansiblels.setup({
	capabilities = capabilities,
	filetypes = { "yaml.ansible" }, -- default
	-- MEMO: filetypeでansibleを検出することにしたのでコメントアウト
	-- filetypes = { "yaml", "yaml.ansible" }, -- Add yaml
	-- single_file_support = false, -- only attach if root_dir detected
})

-- JSON
lspconfig.jsonls.setup({
	capabilities = capabilities,
	-- @ref: https://www.lazyvim.org/extras/lang/json

	-- lazy-load schemastore when needed
	on_new_config = function(new_config)
		new_config.settings.json.schemas = new_config.settings.json.schemas or {}
		vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
	end,
	settings = {
		json = {
			format = {
				enable = true,
			},
			validate = { enable = true },
		},
	},
})

-- MEMO: setup() in lua/plugins/configs/yaml-companion.lua
-- -- YAML
-- lspconfig.yamlls.setup({
-- 	capabilities = capabilities,
-- 	filetypes = { "yaml", "yaml.docker-compose", "yaml.ansible" }, -- attach yamlls and other LSP simultaneously
--
-- 	-- @ref: https://www.lazyvim.org/extras/lang/yaml
--
-- 	-- lazy-load schemastore when needed
-- 	on_new_config = function(new_config)
-- 		new_config.settings.yaml.schemas =
-- 			vim.tbl_deep_extend("force", new_config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
-- 	end,
--
-- 	settings = {
-- 		redhat = { telemetry = { enabled = false } },
-- 		yaml = {
-- 			keyOrdering = false,
-- 			format = {
-- 				enable = true,
-- 			},
-- 			validate = true,
-- 			schemaStore = {
-- 				-- Must disable built-in schemaStore support to use
-- 				-- schemas from SchemaStore.nvim plugin
-- 				enable = false,
-- 				-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
-- 				url = "",
-- 			},
-- 		},
-- 	},
-- })

-- setup multiple servers with same default options
local servers = {
	"html",
	"cssls",
	"tsserver",
	"clangd",
	"dockerls",
	"docker_compose_language_service",
	"bashls",
	"pyright",
	"intelephense",
	"rust_analyzer",
	"eslint",
	"autotools_ls",
	"csharp_ls",
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		capabilities = capabilities,
	})
end

-------------------------------------- LSP other config -----------------------------------

-- adjust popup menu width and height
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	-- opts.border = opts.border or "single"
	-- 画面の大きさに対して%指定でサイズを調整
	opts.max_height = opts.max_height or math.floor(vim.api.nvim_win_get_height(0) * 0.5)
	opts.max_width = opts.max_width or math.floor(vim.api.nvim_win_get_width(0) * 0.7)

	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- setup signcolumn's icon
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅙",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "󰋼",
			[vim.diagnostic.severity.HINT] = "󰌵",
		},
	},
})
