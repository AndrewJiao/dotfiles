local keymapping = require("../keymapping")
local map = keymapping.map
local opts = keymapping.opts


-- 基于comment插件注释 see :h coment.config 
-- map('n','<C-_>','<Plug>(comment_toggle_linewise_current)',opt)
-- map('n','<C-S-_>','<Plug>(comment_toggle_blockwise_current)',opts)
-- map('v','<C-_>','<Plug>(comment_toggle_linewise_visual)',opts)
-- map('v','<C-S-_>','<Plug>(comment_toggle_blockwise_visual)',opts)

return {  
    'numToStr/Comment.nvim',
    config = function()
        require("Comment").setup()
        local ft = require('Comment.ft')
        ft({'yaml'}, '#%s')
        ft({'javascript','json'}, {'//%s', '/*%s*/'})
        ft({'go', 'rust'}, ft.get('c'))
        ft({'toml', 'graphql'}, '#%s')
    end,
}
