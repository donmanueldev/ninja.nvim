return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "auto",
        background = { light = "latte", dark = "mocha" },
        integrations = {
          blink_cmp = true,
          dap = true,
          dap_ui = true,
          diffview = true,
          gitsigns = true,
          mason = true,
          snacks = { enabled = true },
          which_key = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Iconos por tipo de archivo para el árbol, el selector, las pestañas y la barra de estado.
  -- Necesitan una Nerd Font en el terminal.
  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      default = true,
      color_icons = true,
      override_by_filename = {
        artisan = { icon = "\u{e73f}", color = "#F05340", name = "Artisan" },
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>a", group = "Claude (IA)", icon = "󰚩" },
        { "<leader>b", group = "Buffers", icon = "\u{f15c}" },
        { "<leader>c", group = "Código", icon = "\u{f121}" },
        { "<leader>d", group = "Debug", icon = "\u{f188}" },
        { "<leader>f", group = "Buscar", icon = "\u{f002}" },
        { "<leader>g", group = "Git", icon = "\u{e725}" },
        { "<leader>s", group = "Ventanas", icon = "\u{f2d2}" },
        { "<leader>u", group = "Interfaz", icon = "\u{f013}" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = true })
        end,
        desc = "Ver todos los atajos",
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        section_separators = "",
        component_separators = "│",
        disabled_filetypes = { statusline = { "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { { "filename", path = 1 }, "diagnostics" },
        lualine_x = {
          {
            function()
              local names = vim.tbl_map(function(c)
                return c.name
              end, vim.lsp.get_clients({ bufnr = 0 }))
              return table.concat(names, " ")
            end,
            icon = "\u{f0ad}",
          },
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        always_show_bufferline = false,
        diagnostics = "nvim_lsp",
        close_command = function(buf)
          Snacks.bufdelete(buf)
        end,
        right_mouse_command = function(buf)
          Snacks.bufdelete(buf)
        end,
        offsets = {
          { filetype = "snacks_layout_box", text = "Archivos", highlight = "Directory", separator = true },
        },
      },
    },
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Buffer siguiente" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Buffer anterior" },
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Fijar buffer" },
      { "<leader>bh", "<Cmd>BufferLineCloseLeft<CR>", desc = "Cerrar los de la izquierda" },
      { "<leader>bl", "<Cmd>BufferLineCloseRight<CR>", desc = "Cerrar los de la derecha" },
    },
  },
}
