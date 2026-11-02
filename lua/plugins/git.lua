return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame_opts = { delay = 300 },
      on_attach = function(buf)
        local gs = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end
        map("n", "]h", function()
          gs.nav_hunk("next")
        end, "Siguiente cambio")
        map("n", "[h", function()
          gs.nav_hunk("prev")
        end, "Cambio anterior")
        map("n", "<leader>gp", gs.preview_hunk, "Ver cambio")
        map({ "n", "x" }, "<leader>ga", function()
          if vim.fn.mode() == "n" then
            gs.stage_hunk()
          else
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end
        end, "Stage del cambio")
        map({ "n", "x" }, "<leader>gr", function()
          if vim.fn.mode() == "n" then
            gs.reset_hunk()
          else
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end
        end, "Descartar cambio")
        map("n", "<leader>gA", gs.stage_buffer, "Stage del archivo")
        map("n", "<leader>gb", function()
          gs.blame_line({ full = true })
        end, "Blame de la línea")
        map("n", "<leader>ub", gs.toggle_current_line_blame, "Blame en línea")
      end,
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>gd", "<Cmd>DiffviewOpen<CR>", desc = "Ver mis cambios (diff)" },
      { "<leader>gD", "<Cmd>DiffviewOpen origin/HEAD...HEAD<CR>", desc = "Diff de la rama contra main" },
      { "<leader>gh", "<Cmd>DiffviewFileHistory %<CR>", desc = "Historial de este archivo" },
      { "<leader>gq", "<Cmd>DiffviewClose<CR>", desc = "Cerrar diff" },
    },
    opts = {
      enhanced_diff_hl = true,
    },
  },
}
