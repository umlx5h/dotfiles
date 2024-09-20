require("mason").setup({
	-- options.luaで手動で追加しているのでスキップする
	PATH = "skip",
})

local ensure_installed = {
	-- lua stuff
	"lua-language-server",
	"stylua",

	-- shell
	"shfmt",
	"shellcheck",
	"bash-language-server",

	-- web dev stuff
	"css-lsp",
	"html-lsp",

	-- javascript
	"eslint-lsp",
	"typescript-language-server",
	"prettierd",

	-- go
	"gopls",
	"goimports",
	"golangci-lint",
	"golines",
	"gotests", -- not null-ls, for olexsmir/gopher.nvim
	"iferr", -- not null-ls, for olexsmir/gopher.nvim
	"gomodifytags",
	"impl",

	-- C, C++
	"clangd",
	"clang-format",
	"codelldb",

	-- YAML
	"yaml-language-server",
	"ansible-language-server",

	-- JSON
	"json-lsp",

	-- Docker
	"dockerfile-language-server",
	"docker-compose-language-service",

	-- Python
	"pyright",

	-- PHP
	"intelephense",

	-- Rust
	"rust-analyzer",

	-- C#
	"csharp-language-server",

	-- Makefile
	"autotools-language-server",
}

-- custom command to install all mason binaries listed
vim.api.nvim_create_user_command("MasonInstallAll", function()
	vim.cmd("MasonInstall " .. table.concat(ensure_installed, " "))
end, { desc = "Install all mason binaries" })
