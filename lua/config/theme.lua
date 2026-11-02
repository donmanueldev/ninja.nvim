-- Modo claro/oscuro: sigue a macOS, salvo que lo cambies a mano con <leader>ut.
local M = {}

local POLL_MS = 3000
local follow_system = true

local function read_system_sync()
  if vim.fn.has("mac") == 0 then
    return "dark"
  end
  local out = vim.system({ "defaults", "read", "-g", "AppleInterfaceStyle" }, { text = true }):wait()
  return (out.stdout or ""):match("Dark") and "dark" or "light"
end

function M.set(mode)
  if vim.o.background ~= mode then
    vim.o.background = mode
  end
end

function M.toggle()
  follow_system = false
  M.set(vim.o.background == "dark" and "light" or "dark")
  vim.notify("Tema: " .. vim.o.background .. " (manual)", vim.log.levels.INFO)
end

function M.auto()
  follow_system = true
  M.set(read_system_sync())
  vim.notify("Tema: sigue a macOS (" .. vim.o.background .. ")", vim.log.levels.INFO)
end

local function start_polling()
  local timer = vim.uv.new_timer()
  timer:start(POLL_MS, POLL_MS, function()
    if not follow_system then
      return
    end
    vim.system({ "defaults", "read", "-g", "AppleInterfaceStyle" }, { text = true }, function(out)
      local mode = (out.stdout or ""):match("Dark") and "dark" or "light"
      vim.schedule(function()
        if follow_system then
          M.set(mode)
        end
      end)
    end)
  end)
end

function M.setup()
  -- Fijarlo antes de cargar plugins evita el parpadeo y que el terminal lo sobrescriba.
  vim.o.background = read_system_sync()
  if vim.fn.has("mac") == 1 then
    start_polling()
  end
  vim.api.nvim_create_user_command("ThemeToggle", M.toggle, { desc = "Alternar claro/oscuro" })
  vim.api.nvim_create_user_command("ThemeAuto", M.auto, { desc = "Seguir el modo de macOS" })
end

return M
