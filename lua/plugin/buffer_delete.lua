

local keymapping = require("../keymapping")
local map = keymapping.map
local opts = keymapping.opts

return {
  {
    "famiu/bufdelete.nvim",
    config = function()
        vim.keymap.set("n", "<C-F4>", function()
            require("bufdelete").bufdelete(0, false)
            vim.cmd("bn")  -- 自动切换到下一个缓冲区
        end, { desc = "Close & Next Buffer" })
      -- vim.keymap.set("n", "<leader>bD", ":Bdelete!<CR>", { desc = "Force Delete Buffer" })
      -- 关闭其它缓冲区
        vim.keymap.set("n", "<C-S-F3>", function()
            local current_buf = vim.api.nvim_get_current_buf()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if buf ~= current_buf then
                require("bufdelete").bufdelete(buf, false)  -- 不强制关闭
                end
            end
        end, { desc = "Close Other Buffers" })     
    end,
  }
}
