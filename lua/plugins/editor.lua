return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "bash", "blade", "css", "diff", "dockerfile", "git_config", "git_rebase", "gitcommit", "gitignore",
        "go", "gomod", "gosum", "gowork", "html", "java", "javascript", "jsdoc", "json", "kotlin", "lua",
        "luadoc", "markdown", "markdown_inline", "php", "php_only", "phpdoc", "query", "regex", "rust", "scss", "sql",
        "swift", "toml", "tsx", "typescript", "vim", "vimdoc", "xml", "yaml",
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        callback = function(ev)
          if pcall(vim.treesitter.start, ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  { "windwp/nvim-ts-autotag", event = { "BufReadPre", "BufNewFile" }, opts = {} },
  { "folke/ts-comments.nvim", event = "VeryLazy", opts = {} },

  {
    "nvim-mini/mini.nvim",
    event = "VeryLazy",
    config = function()
      require("mini.ai").setup()
      require("mini.pairs").setup()
      require("mini.surround").setup()
    end,
  },

  -- Multicursor: <C-n> selecciona la siguiente coincidencia, como Cmd+D en VS Code
  { "mg979/vim-visual-multi", branch = "master", keys = { { "<C-n>", mode = { "n", "x" } } } },
}
