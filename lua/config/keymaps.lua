-- Atajos generales. Los de cada plugin viven en su spec (lua/plugins/*).
local map = vim.keymap.set

-- Modo normal y guardar
map("i", "jk", "<Esc>", { desc = "Salir de inserción" })
map({ "n", "i", "x" }, "<C-s>", "<Cmd>write<CR><Esc>", { desc = "Guardar" })
map("n", "<leader>w", "<Cmd>write<CR>", { desc = "Guardar" })
map("n", "<leader>q", "<Cmd>quit<CR>", { desc = "Cerrar ventana" })
map("n", "<leader>Q", "<Cmd>quitall<CR>", { desc = "Salir de Neovim" })
map("n", "<Esc>", "<Cmd>nohlsearch<CR>", { desc = "Limpiar búsqueda" })

-- Edición
map("n", "<C-a>", "ggVG", { desc = "Seleccionar todo" })
map("x", "J", ":move '>+1<CR>gv=gv", { silent = true, desc = "Mover selección abajo" })
map("x", "K", ":move '<-2<CR>gv=gv", { silent = true, desc = "Mover selección arriba" })
map("x", "<", "<gv", { desc = "Quitar sangría" })
map("x", ">", ">gv", { desc = "Añadir sangría" })
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
-- Comentar como en VS Code (el terminal envía <C-/> como <C-_>)
for _, key in ipairs({ "<C-/>", "<C-_>" }) do
  map("n", key, "gcc", { remap = true, desc = "Comentar línea" })
  map("x", key, "gc", { remap = true, desc = "Comentar selección" })
end

-- Moverse entre ventanas
for key, dir in pairs({ h = "h", j = "j", k = "k", l = "l", Left = "h", Down = "j", Up = "k", Right = "l" }) do
  map("n", ("<C-%s>"):format(key), "<C-w>" .. dir, { desc = "Ir a ventana " .. dir })
end

-- Crear, cerrar y redimensionar ventanas
map("n", "<leader>sv", "<Cmd>vsplit<CR>", { desc = "Dividir vertical" })
map("n", "<leader>sh", "<Cmd>split<CR>", { desc = "Dividir horizontal" })
map("n", "<leader>sx", "<Cmd>close<CR>", { desc = "Cerrar ventana" })
map("n", "<leader>so", "<Cmd>only<CR>", { desc = "Dejar solo esta ventana" })
map("n", "<leader>s=", "<C-w>=", { desc = "Igualar tamaños" })
map("n", "<S-Up>", "<Cmd>resize +2<CR>", { desc = "Más alta" })
map("n", "<S-Down>", "<Cmd>resize -2<CR>", { desc = "Menos alta" })
map("n", "<S-Left>", "<Cmd>vertical resize -4<CR>", { desc = "Más estrecha" })
map("n", "<S-Right>", "<Cmd>vertical resize +4<CR>", { desc = "Más ancha" })

-- Terminal: <C-q> vuelve a modo normal (el doble Esc se reserva para Claude Code)
map("t", "<C-q>", "<C-\\><C-n>", { desc = "Terminal: modo normal" })

-- Tema
map("n", "<leader>ut", function()
  require("config.theme").toggle()
end, { desc = "Alternar claro/oscuro" })
map("n", "<leader>uT", function()
  require("config.theme").auto()
end, { desc = "Tema: seguir a macOS" })

-- Herramientas
map("n", "<leader>L", "<Cmd>Lazy<CR>", { desc = "Plugins (Lazy)" })
map("n", "<leader>M", "<Cmd>Mason<CR>", { desc = "Servidores (Mason)" })
