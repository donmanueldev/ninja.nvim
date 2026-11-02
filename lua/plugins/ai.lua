-- Claude Code dentro de Neovim, con el mismo protocolo que la extensión de VS Code:
-- ve tu selección y archivo actual, y propone cambios como diffs que aceptas o rechazas.
return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  cmd = { "ClaudeCode", "ClaudeCodeFocus", "ClaudeCodeSend", "ClaudeCodeAdd", "ClaudeCodeTreeAdd" },
  opts = {
    terminal = {
      provider = "snacks",
      split_side = "right",
      split_width_percentage = 0.38,
      -- Sin esto, el doble Esc de Claude Code (retroceder) lo capturaría la ventana
      snacks_win_opts = { keys = { term_normal = false } },
    },
    diff_opts = { open_in_current_tab = true },
  },
  keys = {
    { "<leader>ac", "<Cmd>ClaudeCode<CR>", desc = "Abrir/cerrar Claude" },
    { "<leader>af", "<Cmd>ClaudeCodeFocus<CR>", desc = "Enfocar Claude" },
    { "<leader>ar", "<Cmd>ClaudeCode --resume<CR>", desc = "Retomar sesión" },
    { "<leader>aC", "<Cmd>ClaudeCode --continue<CR>", desc = "Continuar última sesión" },
    { "<leader>am", "<Cmd>ClaudeCodeSelectModel<CR>", desc = "Elegir modelo" },
    { "<leader>ab", "<Cmd>ClaudeCodeAdd %<CR>", desc = "Añadir este archivo" },
    { "<leader>as", "<Cmd>ClaudeCodeSend<CR>", mode = "x", desc = "Enviar selección" },
    { "<leader>aa", "<Cmd>ClaudeCodeDiffAccept<CR>", desc = "Aceptar cambio" },
    { "<leader>ad", "<Cmd>ClaudeCodeDiffDeny<CR>", desc = "Rechazar cambio" },
  },
}
