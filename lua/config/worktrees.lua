-- Selector de git worktrees: cambia el directorio de trabajo al elegido.
local M = {}

local function list()
  local out = vim.system({ "git", "worktree", "list", "--porcelain" }, { text = true }):wait()
  if out.code ~= 0 then
    return nil
  end
  local items, current = {}, nil
  for line in out.stdout:gmatch("[^\n]+") do
    local path = line:match("^worktree (.+)")
    if path then
      current = { path = path, branch = "(detached)" }
      table.insert(items, current)
    elseif current then
      local branch = line:match("^branch refs/heads/(.+)")
      current.branch = branch or current.branch
    end
  end
  for _, item in ipairs(items) do
    item.text = ("%-28s %s"):format(item.branch, vim.fn.fnamemodify(item.path, ":~"))
  end
  return items
end

function M.pick()
  local items = list()
  if not items then
    vim.notify("No es un repositorio git", vim.log.levels.WARN)
    return
  end
  Snacks.picker.pick({
    title = "Git worktrees",
    items = items,
    format = "text",
    layout = { preset = "select" },
    confirm = function(picker, item)
      picker:close()
      if item then
        vim.cmd.cd(vim.fn.fnameescape(item.path))
        vim.notify("Worktree: " .. item.branch)
        Snacks.picker.files()
      end
    end,
  })
end

return M
