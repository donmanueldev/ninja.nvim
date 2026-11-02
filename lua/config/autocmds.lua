local group = vim.api.nvim_create_augroup("user_config", { clear = true })
local autocmd = function(event, opts)
  opts.group = group
  vim.api.nvim_create_autocmd(event, opts)
end

-- Recarga archivos cambiados fuera del buffer (Claude Code, lazygit, git checkout...)
autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermClose", "TermLeave" }, {
  callback = function()
    if vim.fn.getcmdwintype() == "" and vim.bo.buftype ~= "nofile" then
      vim.cmd.checktime()
    end
  end,
})

autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank({ timeout = 150 })
  end,
})

-- Reabre cada archivo en la última línea editada
autocmd("BufReadPost", {
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

autocmd("VimResized", {
  command = "tabdo wincmd =",
})

-- Ventanas auxiliares: q para cerrar
autocmd("FileType", {
  pattern = { "checkhealth", "help", "lspinfo", "man", "qf" },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = ev.buf, silent = true })
  end,
})

-- Sangría de 4 espacios o tabs según la convención de cada lenguaje
autocmd("FileType", {
  pattern = { "php", "java", "kotlin", "swift", "blade", "rust" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
})
autocmd("FileType", {
  pattern = { "go" },
  callback = function()
    vim.bo.expandtab = false
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
})
