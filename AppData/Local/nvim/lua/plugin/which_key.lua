-- 安装
return  {
  "folke/which-key.nvim",
  config = function()
    local wk = require("which-key").setup {
      -- 可选配置（详见文档）
      plugins = { spelling = { enabled = true } },
      win = { border = "single" }, -- 浮动窗口样式
    }

  end
}
