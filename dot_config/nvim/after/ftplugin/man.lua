vim.opt_local.smoothscroll = true

local aerial = require("aerial")

local function aerial_open()
	-- manコマンド経由で起動したかどうかを判定
	if not vim.g.pager then
		return
	end

	if not aerial.is_open() then
		aerial.open({ focus = false, direction = "right" })
	end

	-- 以下で定義されたqボタンを押した時に、aerialも同時に閉じるように修正
	-- :e /usr/share/nvim/runtime/ftplugin/man.vim:28
	vim.keymap.set("n", "q", "<cmd>AerialClose<CR>:lclose<CR><C-W>q", { silent = true, buffer = true, nowait = true })
end

-- Aerialを常に開いておく
aerial_open()
