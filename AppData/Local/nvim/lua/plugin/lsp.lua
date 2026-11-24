local keymapping = require("../keymapping")
local map = keymapping.map
local opts = keymapping.opts
  -- LSP 基础配置
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        {"williamboman/mason.nvim", build = ":MasonUpdate" },
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp", -- 用于自动补全 LSP 支持
    },
    config = function()
      local lspconfig = require("lspconfig")
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      mason.setup()
      mason_lspconfig.setup({
        ensure_installed = { "lua_ls", "tsserver", "jsonls", "gopls", "html", "cssls" },
        automatic_installation = true,
      })

      -- LSP 公共默认 on_attach 函数
      local on_attach = function(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "gd", gim.lsp.buf.definition, "[G]oto [D]efinition")
        map("n", "gr", vim.lsp.buf.references, "[G]oto [R]eferences")
        map("n", "K", vim.lsp.buf.hover, "Hover")
        map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        map("n", "[d", vin.diagnostic.goto_prev, "Prev Diagnostic")
        map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
        map("n", "<leader>e", vim.diagnostic.open_float, "Show Diagnostic")
        map("n", "<leader>q", vim.diagnostic.setloclist, "Quickfix List")
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local cmp_lsp = require("cmp_nvim_lsp")
      capabilities = cmp_lsp.default_capabilities(capabilities)

      -- 自动格式化
      local lsp_format_on_save = function(client, bufnr)
        if client.server_capabilities.documentFormattingProvider then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end

      -- 针对每个 LSP 服务器的设置
      mason_lspconfig.setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({
            on_attach = function(client, bufnr)
              on_attach(client, bufnr)
              lsp_format_on_save(client, bufnr)
            end,
            capabilities = capabilities,
          })
        end,
      })
    end,
  },
}
