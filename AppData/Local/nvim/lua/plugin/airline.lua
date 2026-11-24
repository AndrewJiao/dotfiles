

local keymapping = require("../keymapping")
local map = keymapping.map
local opts = keymapping.opts


-- local F={}
-- function F.delete_other()
--   -- 获取当前缓冲区 ID
--   local current_buf = vim.api.nvim_get_current_buf()
--   -- 遍历所有缓冲区，关闭非当前缓冲区
--   for _, buf in ipairs(vim.api.nvim_list_bufs()) do
--     if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
--       vim.cmd("bdelete " .. buf)
--     end
--   end
-- end

-- 缓冲区切换快捷键
vim.keymap.set("n", "<A-l>", ":bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<A-h>", ":bprev<CR>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<A-L>", ":bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<A-H>", ":bprev<CR>", { desc = "Prev Buffer" })
vim.keymap.set("i", "<A-l>", ":bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("i", "<A-h>", ":bprev<CR>", { desc = "Prev Buffer" })
vim.keymap.set("i", "<A-L>", ":bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("i", "<A-H>", ":bprev<CR>", { desc = "Prev Buffer" })
-- 关闭其他所有缓冲区（仅保留当前）
-- vim.keymap.set("n", "<C-F4>", ":bp<bar>bd #<CR>", { desc = "Close Buffer Keep Window" })
-- vim.keymap.set("n", "<C-S-F3>", F.delete_other, { desc = "Close Other Buffers" })
-- vim.keymap.set("n", "<C-S-F3>", ":silent! %bd<bar>e #<CR>", { desc = "Close Other Buffers" })

local M = {
    {
        "vim-airline/vim-airline",
        init = function()
            -- 启用顶部标签栏
            vim.g["airline#extensions#tabline#enabled"] = 1
            -- 使用 Powerline 字体（可选）
            vim.g.airline_powerline_fonts = 1                
            -- 设置主题（可选）
            vim.g.airline_theme = "dark"                     
            vim.g['airline#extensions#tabline#left_sep'] = ' '
            vim.g['airline#extensions#tabline#left_alt_sep'] = '|'
            vim.g['airline#extensions#tabline#formatter'] = 'unique_tail_improved'
        end,
    },
    'vim-airline/vim-airline-themes'
}



return M
