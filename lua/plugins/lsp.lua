return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
    },
    config = function()
      -- Setup neodev for Neovim lua development
      require("neodev").setup()
      -- Setup mason
      require("mason").setup({
        ui = {
          border = "rounded",
        },
      })
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "pyright",
          "rust_analyzer",
          "gopls",
          "intelephense",
          "vue_ls",
          "eslint",
        },
        automatic_installation = true,
      })
      -- LSP settings
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      -- Keymaps
      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr, noremap = true, silent = true }
        local keymap = vim.keymap.set
        keymap("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
        keymap("n", "gD", vim.lsp.buf.declaration, opts)
        keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
        keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
        keymap("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
        keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
        keymap("n", "<leader>dd", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
        keymap("n", "<leader>dl", vim.diagnostic.open_float, opts)
        keymap("n", "[d", vim.diagnostic.goto_prev, opts)
        keymap("n", "]d", vim.diagnostic.goto_next, opts)
        keymap("n", "K", vim.lsp.buf.hover, opts)
        keymap("n", "<leader>rs", ":LspRestart<CR>", opts)
      end
      -- Configure servers
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
              },
            },
          },
        },
      })
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      lspconfig.gopls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      })
      lspconfig.intelephense.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          intelephense = {
            files = {
              maxSize = 5000000,
            },
          },
        },
      })
      lspconfig.vue_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "vue" },
      })
      lspconfig.eslint.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      -- Configure diagnostics
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
        },
      })
    end,
  },
  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      cmp.setup({
        completion = {
          completeopt = "menu,menuone,preview,noselect",
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
  -- Formatting
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")
      conform.setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          vue = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          lua = { "stylua" },
          python = { "isort", "black" },
          go = { "goimports", "gofumpt" },
          php = { "php_cs_fixer" },
        },
        format_on_save = {
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        },
      })
      vim.keymap.set({ "n", "v" }, "<leader>mp", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        })
      end, { desc = "Format file or range (in visual mode)" })
    end,
  },
}
