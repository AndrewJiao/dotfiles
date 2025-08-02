
local keymapping = require("../keymapping")
local map = keymapping.map
local opts = keymapping.opts


map('n', '<S-A-k>', '<Plug>MoveLineUp')
map('n', '<S-A-j>', '<Plug>MoveLineDown')
map('v', '<S-A-k>', '<Plug>MoveBlockUp')
map('v', '<S-A-j>', '<Plug>MoveBlockDown')
map('n', '<S-A-l>', '<Plug>MoveLineRight')
map('n', '<S-A-h>', '<Plug>MoveLineLeft')
map('v', '<S-A-l>', '<Plug>MoveBlockRight')
map('v', '<S-A-h>', '<Plug>MoveBlockLeft')
vim.g.move_key_modifier_visualmode = '0'
vim.g.move_key_modifier = '0'

local M = {
    'matze/vim-move'
}


return M
