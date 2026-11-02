-- Servidores LSP. Mason los instala; sourcekit (Swift) viene con Xcode y jdtls (Java) lo arranca java.lua.
local servers = {
  -- JavaScript, TypeScript, React y React Native
  vtsls = {
    settings = {
      vtsls = { autoUseWorkspaceTsdk = true },
      typescript = {
        updateImportsOnFileMove = { enabled = "always" },
        inlayHints = {
          parameterNames = { enabled = "literals" },
          functionLikeReturnTypes = { enabled = true },
        },
      },
    },
  },
  eslint = {},

  -- Web
  html = { filetypes = { "html", "blade" } },
  cssls = {},
  tailwindcss = {},
  emmet_language_server = {
    filetypes = { "html", "blade", "css", "scss", "javascriptreact", "typescriptreact" },
  },

  -- Datos y configuración
  jsonls = {
    settings = {
      json = { validate = { enable = true } },
    },
    before_init = function(_, config)
      config.settings.json.schemas = require("schemastore").json.schemas()
    end,
  },
  yamlls = {
    settings = {
      yaml = { schemaStore = { enable = false, url = "" } },
    },
    before_init = function(_, config)
      config.settings.yaml.schemas = require("schemastore").yaml.schemas()
    end,
  },
  taplo = {},

  -- PHP y Laravel
  intelephense = {
    init_options = { globalStoragePath = vim.fn.stdpath("cache") .. "/intelephense" },
    settings = {
      intelephense = { files = { maxSize = 5000000 } },
    },
  },
  laravel_ls = {}, -- rutas, vistas, config y .env; solo se activa si hay un archivo artisan

  -- Go
  gopls = {
    settings = {
      gopls = {
        gofumpt = true,
        staticcheck = true,
        semanticTokens = true,
        analyses = { unusedparams = true, unusedwrite = true, shadow = true },
        hints = { parameterNames = true, assignVariableTypes = true },
      },
    },
  },

  -- Rust
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = { check = { command = "clippy" } },
    },
  },

  -- Kotlin
  kotlin_lsp = {},

  -- Lua
  lua_ls = {
    settings = {
      Lua = { completion = { callSnippet = "Replace" }, workspace = { checkThirdParty = false } },
    },
  },
}

local function on_attach(ev)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc, nowait = true })
  end

  map("n", "gd", function() Snacks.picker.lsp_definitions() end, "Ir a la definición")
  map("n", "gD", vim.lsp.buf.declaration, "Ir a la declaración")
  map("n", "gr", function() Snacks.picker.lsp_references() end, "Ver referencias")
  map("n", "gi", function() Snacks.picker.lsp_implementations() end, "Ir a la implementación")
  map("n", "gy", function() Snacks.picker.lsp_type_definitions() end, "Ir al tipo")
  map("n", "K", vim.lsp.buf.hover, "Documentación")
  map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Acciones de código")
  map("n", "<leader>cr", vim.lsp.buf.rename, "Renombrar símbolo")
  map("n", "<F2>", vim.lsp.buf.rename, "Renombrar símbolo")
  map("n", "<leader>cd", vim.diagnostic.open_float, "Ver problema de la línea")
  map("n", "<leader>cs", function() Snacks.picker.lsp_symbols() end, "Símbolos del archivo")
  map("n", "<leader>cS", function() Snacks.picker.lsp_workspace_symbols() end, "Símbolos del proyecto")
  map("n", "<leader>cl", "<Cmd>checkhealth vim.lsp<CR>", "Estado de LSP")
end

return {
  { "b0o/SchemaStore.nvim" },

  {
    "mason-org/mason.nvim",
    lazy = false,
    opts = {},
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        -- LSP
        "vtsls", "eslint-lsp", "html-lsp", "css-lsp", "tailwindcss-language-server", "emmet-language-server",
        "json-lsp", "yaml-language-server", "taplo", "intelephense", "laravel-ls", "gopls", "rust-analyzer", "kotlin-lsp", "lua-language-server",
        "jdtls",
        -- Formato
        "prettierd", "stylua", "goimports", "gofumpt", "pint", "blade-formatter", "ktlint",
        -- Lint
        "golangci-lint",
        -- Debug
        "js-debug-adapter", "php-debug-adapter", "delve", "java-debug-adapter", "java-test", "kotlin-debug-adapter",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim", "b0o/SchemaStore.nvim", "saghen/blink.cmp" },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp", { clear = true }),
        callback = on_attach,
      })

      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
      vim.lsp.config("sourcekit", { cmd = { "xcrun", "sourcekit-lsp" } })
      vim.lsp.enable("sourcekit")

      for name, config in pairs(servers) do
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
      end
    end,
  },
}
