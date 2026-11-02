local o = vim.opt

-- Interfaz
o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.cursorline = true
o.colorcolumn = "120"
o.termguicolors = true
o.showmode = false
o.laststatus = 3
o.winborder = "rounded"
o.scrolloff = 8
o.sidescrolloff = 8
o.wrap = false
o.linebreak = true
o.pumheight = 12
o.splitright = true
o.splitbelow = true
o.splitkeep = "screen"
o.mouse = "a"
o.confirm = true

-- Edición
o.clipboard = "unnamedplus"
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.smartindent = true
o.undofile = true
o.swapfile = false
o.autowrite = true
o.autoread = true

-- Búsqueda
o.ignorecase = true
o.smartcase = true
o.inccommand = "split"
o.grepprg = "rg --vimgrep --smart-case"

-- Rendimiento
o.updatetime = 250
o.timeoutlen = 400

-- Folds con treesitter, todo abierto por defecto
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldtext = ""
o.foldlevel = 99

vim.filetype.add({
  extension = { env = "sh" },
  filename = { [".env"] = "sh" },
  pattern = {
    [".*%.blade%.php"] = "blade",
    ["%.env%..*"] = "sh",
    ["tsconfig.*%.json"] = "jsonc",
  },
})

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { prefix = "●", spacing = 2 },
  float = { source = "if_many" },
  jump = { float = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "\u{f057} ",
      [vim.diagnostic.severity.WARN] = "\u{f071} ",
      [vim.diagnostic.severity.INFO] = "\u{f05a} ",
      [vim.diagnostic.severity.HINT] = "\u{f0eb} ",
    },
  },
})
