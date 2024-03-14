-------------------------------------- filetypes ------------------------------------------

local yamlAnsible = "yaml.ansible"
vim.filetype.add({
	pattern = {
		-- docker compose
		["docker.compose.*%.ya?ml"] = "yaml.docker-compose",

		-- ansible
		[".*/playbooks?/.*%.ya?ml"] = yamlAnsible,
		[".*/roles/.*/tasks/.*%.ya?ml"] = yamlAnsible,
		[".*/roles/.*/handlers/.*%.ya?ml"] = yamlAnsible,
		[".*playbook.*%.ya?ml"] = yamlAnsible,
	},
})

-------------------------------------- nvim stuff ------------------------------------------

-- disable some default providers
for _, provider in ipairs({ "node", "perl", "python3", "ruby" }) do
	vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- editorconfigでindent_sizeのみ指定された時にtabstopが書き換えられるのを無効化する
-- copy from https://github.com/neovim/neovim/blob/e6d38c7dac2e079d9b0f1621fef193bca858664f/runtime/lua/editorconfig.lua#L59-L71
require("editorconfig").properties.indent_size = function(bufnr, val, opts)
	if val == "tab" then
		vim.bo[bufnr].shiftwidth = 0
		vim.bo[bufnr].softtabstop = 0
	else
		local n = assert(tonumber(val), "indent_size must be a number")
		vim.bo[bufnr].shiftwidth = n
		vim.bo[bufnr].softtabstop = -1

		-- MEMO: comment out for keeping tabstop to 8
		-- if not opts.tab_width then
		-- 	vim.bo[bufnr].tabstop = n
		-- end
	end
end

---------------------------------------- lua functions ----------------------------------------

-- MacかWSL2の場合はローカルと判定、それ以外はリモート扱い
function Is_local()
	local uname = vim.loop.os_uname()
	local isLocal = uname.sysname == "Darwin" or uname.sysname == "Linux" and uname.release:find("microsoft")
	return isLocal
end

-------------------------------------- local options ------------------------------------------

if not Is_local() then
	-- ローカル以外はOSC52でクリップボードを扱う
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			["+"] = require("vim.ui.clipboard.osc52").paste("+"),
			["*"] = require("vim.ui.clipboard.osc52").paste("*"),
		},
	}
end
