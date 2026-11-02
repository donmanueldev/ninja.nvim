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
        -- Bases más neutras y mejor contraste que los pasteles originales.
        color_overrides = {
          mocha = {
            text = "#dcdee8",
            subtext1 = "#bcbfcb",
            subtext0 = "#a6a9b6",
            overlay2 = "#8f92a0",
            overlay1 = "#777a86",
            overlay0 = "#5c5f6b",
            surface2 = "#454752",
            surface1 = "#33353f",
            surface0 = "#24262f",
            base = "#14151b",
            mantle = "#0f1015",
            crust = "#0b0c10",
          },
          latte = {
            rosewater = "#a8574a",
            flamingo = "#b3545a",
            pink = "#b5317f",
            mauve = "#7a2fd6",
            red = "#c9163a",
            maroon = "#b83347",
            peach = "#b84a06",
            yellow = "#8a5d00",
            green = "#2f7d1f",
            teal = "#0f7c83",
            sky = "#0a7ea8",
            sapphire = "#11709c",
            blue = "#1a5fd6",
            lavender = "#4953b8",
            text = "#26272e",
            subtext1 = "#43454e",
            subtext0 = "#53565f",
            overlay2 = "#666974",
            overlay1 = "#7d808c",
            overlay0 = "#9a9ca8",
            surface2 = "#b9bbc4",
            surface1 = "#d2d3da",
            surface0 = "#e2e2e7",
            base = "#fafafa",
            mantle = "#f2f2f4",
            crust = "#e8e8ec",
          },
        },
        -- Bordes, guías y números discretos: el código es lo que debe destacar.
        custom_highlights = function(c)
          return {
            LineNr = { fg = c.overlay0 },
            CursorLineNr = { fg = c.text, style = { "bold" } },
            ColorColumn = { bg = c.mantle },
            WinSeparator = { fg = c.surface0 },
            NormalFloat = { fg = c.text, bg = c.mantle },
            FloatBorder = { fg = c.surface2, bg = c.mantle },
            FloatTitle = { fg = c.subtext1, bg = c.mantle, style = { "bold" } },
            Pmenu = { fg = c.subtext1, bg = c.mantle },
            SnacksPickerBox = { bg = c.mantle },
            SnacksIndent = { fg = c.surface0 },
            SnacksIndentScope = { fg = c.surface2 },
          }
        end,
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
        component_separators = "",
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
    opts = function()
      return {
        highlights = require("catppuccin.special.bufferline").get_theme(),
        options = {
          always_show_bufferline = false,
          diagnostics = "nvim_lsp",
          indicator = { style = "none" },
          show_buffer_close_icons = false,
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
      }
    end,
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Buffer siguiente" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Buffer anterior" },
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Fijar buffer" },
      { "<leader>bh", "<Cmd>BufferLineCloseLeft<CR>", desc = "Cerrar los de la izquierda" },
      { "<leader>bl", "<Cmd>BufferLineCloseRight<CR>", desc = "Cerrar los de la derecha" },
    },
  },
}
