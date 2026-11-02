-- Un solo plugin para selector, árbol de archivos, terminal, lazygit, notificaciones y dashboard.
local function pick(source, opts)
  return function()
    Snacks.picker[source](opts)
  end
end

return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 900,
  opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    input = { enabled = true },
    indent = { enabled = true },
    notifier = { enabled = true },
    words = { enabled = true },
    statuscolumn = { enabled = true },
    explorer = { replace_netrw = true },
    dashboard = {
      enabled = true,
      sections = {
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
      preset = {
        keys = {
          { icon = "\u{f15b} ", key = "f", desc = "Buscar archivo", action = ":lua Snacks.picker.files()" },
          { icon = "\u{f002} ", key = "g", desc = "Buscar texto", action = ":lua Snacks.picker.grep()" },
          { icon = "\u{f017} ", key = "r", desc = "Recientes", action = ":lua Snacks.picker.recent()" },
          { icon = "\u{f07b} ", key = "e", desc = "Árbol de archivos", action = ":lua Snacks.explorer()" },
          { icon = "\u{e725} ", key = "G", desc = "Lazygit", action = ":lua Snacks.lazygit()" },
          { icon = "󰒲 ", key = "L", desc = "Plugins", action = ":Lazy" },
          { icon = "\u{f011} ", key = "q", desc = "Salir", action = ":qa" },
        },
      },
    },
    picker = {
      sources = {
        files = { hidden = true },
        grep = { hidden = true },
        explorer = {
          hidden = true,
          ignored = true,
          exclude = { ".git", ".DS_Store" },
          layout = { layout = { width = 34 } },
        },
      },
    },
    terminal = { win = { position = "bottom", height = 0.3 } },
  },
  keys = {
    -- Archivos
    { "<leader>e", function() Snacks.explorer() end, desc = "Árbol de archivos" },
    { "<leader>n", function() Snacks.explorer() end, desc = "Árbol de archivos" },
    { "<C-b>", function() Snacks.explorer() end, desc = "Árbol de archivos" },
    { "<C-p>", pick("files"), desc = "Buscar archivo" },
    { "<leader><space>", pick("smart"), desc = "Búsqueda inteligente" },

    -- Buscar
    { "<leader>ff", pick("files"), desc = "Archivos" },
    { "<leader>fa", pick("files", { ignored = true }), desc = "Archivos (incluye ignorados)" },
    { "<leader>fg", pick("grep"), desc = "Texto en el proyecto" },
    { "<leader>fw", pick("grep_word"), mode = { "n", "x" }, desc = "Palabra bajo el cursor" },
    { "<leader>fb", pick("buffers"), desc = "Buffers abiertos" },
    { "<leader>fr", pick("recent"), desc = "Recientes" },
    { "<leader>f/", pick("lines"), desc = "En este archivo" },
    { "<leader>fh", pick("help"), desc = "Ayuda de Neovim" },
    { "<leader>fk", pick("keymaps"), desc = "Atajos" },
    { "<leader>fc", pick("commands"), desc = "Comandos" },
    { "<leader>fn", pick("notifications"), desc = "Notificaciones" },
    { "<leader>fR", pick("resume"), desc = "Repetir última búsqueda" },

    -- Git
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>gs", pick("git_status"), desc = "Archivos cambiados" },
    { "<leader>gl", pick("git_log"), desc = "Commits" },
    { "<leader>gf", pick("git_log_file"), desc = "Commits de este archivo" },
    { "<leader>gB", pick("git_branches"), desc = "Ramas" },
    { "<leader>go", function() Snacks.gitbrowse() end, mode = { "n", "x" }, desc = "Abrir en GitHub" },
    { "<leader>gw", function() require("config.worktrees").pick() end, desc = "Worktrees" },

    -- Buffers
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Cerrar buffer" },
    { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Cerrar los demás" },

    -- Ventanas y terminal
    { "<leader>sm", function() Snacks.zen.zoom() end, desc = "Maximizar ventana" },
    { "<leader>t", function() Snacks.terminal() end, desc = "Terminal" },
    { "<C-\\>", function() Snacks.terminal() end, mode = { "n", "t" }, desc = "Terminal" },

    -- Diagnósticos
    { "<leader>cx", pick("diagnostics_buffer"), desc = "Problemas de este archivo" },
    { "<leader>cX", pick("diagnostics"), desc = "Problemas del proyecto" },

    -- Interfaz
    { "<leader>uw", function() Snacks.toggle.option("wrap"):toggle() end, desc = "Ajuste de línea" },
    { "<leader>ud", function() Snacks.toggle.diagnostics():toggle() end, desc = "Diagnósticos" },
    { "<leader>uh", function() Snacks.toggle.inlay_hints():toggle() end, desc = "Inlay hints" },
    { "<leader>uz", function() Snacks.zen() end, desc = "Modo zen" },
  },
}
