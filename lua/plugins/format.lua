-- Al guardar: primero los arreglos de ESLint, después el formateador del lenguaje.
local web = { "prettierd", "prettier", stop_after_first = true }

local function eslint_fix(buf)
  if #vim.lsp.get_clients({ bufnr = buf, name = "eslint" }) > 0 and vim.fn.exists(":LspEslintFixAll") == 2 then
    pcall(vim.cmd.LspEslintFixAll)
  end
end

return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "x" },
        desc = "Formatear",
      },
      {
        "<leader>uf",
        function()
          vim.g.autoformat_disabled = not vim.g.autoformat_disabled
          vim.notify("Formato al guardar: " .. (vim.g.autoformat_disabled and "apagado" or "encendido"))
        end,
        desc = "Formato al guardar",
      },
    },
    config = function()
      local conform = require("conform")
      conform.setup({
        formatters_by_ft = {
          javascript = web,
          javascriptreact = web,
          typescript = web,
          typescriptreact = web,
          css = web,
          scss = web,
          html = web,
          json = web,
          jsonc = web,
          yaml = web,
          markdown = web,
          php = { "pint" },
          blade = { "blade-formatter" },
          go = { "goimports", "gofumpt" },
          rust = { "rustfmt" },
          kotlin = { "ktlint" },
          swift = { "swift_format" },
          toml = { "taplo" },
          lua = { "stylua" },
          -- Java usa el formateador de jdtls
        },
        formatters = {
          swift_format = {
            command = "xcrun",
            args = { "swift-format", "format", "--assume-filename", "$FILENAME", "-" },
            stdin = true,
          },
        },
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("user_format", { clear = true }),
        callback = function(ev)
          if vim.g.autoformat_disabled then
            return
          end
          eslint_fix(ev.buf)
          conform.format({ bufnr = ev.buf, timeout_ms = 3000, lsp_format = "fallback" })
        end,
      })
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost" },
    config = function()
      local lint = require("lint")
      -- JS/TS los cubre el servidor de ESLint. Estos solo corren si la herramienta existe.
      local linters = {
        go = { "golangcilint" },
        kotlin = { "ktlint" },
        swift = { "swiftlint" },
        php = { "phpstan" },
      }

      local function has_tool(name)
        local cmd = lint.linters[name].cmd
        if type(cmd) == "function" then
          cmd = cmd()
        end
        return vim.fn.executable(cmd) == 1
      end

      local function run()
        for _, name in ipairs(linters[vim.bo.filetype] or {}) do
          if has_tool(name) then
            lint.try_lint(name)
          end
        end
      end

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
        group = vim.api.nvim_create_augroup("user_lint", { clear = true }),
        callback = run,
      })
      run()
    end,
  },
}
