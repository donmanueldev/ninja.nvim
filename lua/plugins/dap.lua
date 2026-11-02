-- Debug. nvim-dap también lee .vscode/launch.json si el proyecto lo tiene.
local function mason_bin(name)
  return vim.fn.stdpath("data") .. "/mason/bin/" .. name
end

local function ask_program(subdir)
  return function()
    return vim.fn.input("Ejecutable: ", vim.fn.getcwd() .. "/" .. subdir, "file")
  end
end

local function setup_javascript(dap)
  for _, adapter in ipairs({ "pwa-node", "pwa-chrome" }) do
    dap.adapters[adapter] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = { command = mason_bin("js-debug-adapter"), args = { "${port}" } },
    }
  end

  local configs = {
    {
      name = "Node: ejecutar este archivo",
      type = "pwa-node",
      request = "launch",
      program = "${file}",
      cwd = "${workspaceFolder}",
      sourceMaps = true,
    },
    {
      name = "Node: conectar a un proceso",
      type = "pwa-node",
      request = "attach",
      processId = function()
        return require("dap.utils").pick_process()
      end,
      cwd = "${workspaceFolder}",
    },
    {
      name = "Chrome: abrir la app web",
      type = "pwa-chrome",
      request = "launch",
      url = function()
        return vim.fn.input("URL: ", "http://localhost:5173")
      end,
      webRoot = "${workspaceFolder}",
      sourceMaps = true,
    },
  }
  for _, ft in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
    dap.configurations[ft] = configs
  end
end

local function setup_php(dap)
  dap.adapters.php = { type = "executable", command = mason_bin("php-debug-adapter") }
  dap.configurations.php = {
    {
      name = "Xdebug: escuchar (puerto 9003)",
      type = "php",
      request = "launch",
      port = 9003,
      pathMappings = { ["/var/www/html"] = "${workspaceFolder}" },
    },
    {
      name = "PHP: ejecutar este archivo",
      type = "php",
      request = "launch",
      port = 9003,
      program = "${file}",
      cwd = "${fileDirname}",
    },
  }
  dap.configurations.blade = dap.configurations.php
end

-- Swift y Rust comparten lldb-dap, que viene con Xcode
local function setup_lldb(dap)
  dap.adapters.lldb = { type = "executable", command = "xcrun", args = { "lldb-dap" }, name = "lldb" }
  local function config(name, subdir)
    return {
      {
        name = name,
        type = "lldb",
        request = "launch",
        program = ask_program(subdir),
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }
  end
  dap.configurations.swift = config("Swift: ejecutar binario", ".build/debug/")
  dap.configurations.rust = config("Rust: ejecutar binario", "target/debug/")
end

local function setup_kotlin(dap)
  dap.adapters.kotlin = { type = "executable", command = mason_bin("kotlin-debug-adapter") }
  dap.configurations.kotlin = {
    {
      name = "Kotlin: ejecutar clase principal",
      type = "kotlin",
      request = "launch",
      projectRoot = "${workspaceFolder}",
      mainClass = function()
        return vim.fn.input("Clase principal: ", "MainKt")
      end,
    },
  }
end

local function dap_call(method)
  return function()
    require("dap")[method]()
  end
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        keys = {
          { "<leader>du", function() require("dapui").toggle() end, desc = "Mostrar/ocultar paneles" },
          { "<leader>de", function() require("dapui").eval() end, mode = { "n", "x" }, desc = "Evaluar expresión" },
        },
        config = function()
          local dap, dapui = require("dap"), require("dapui")
          dapui.setup()
          dap.listeners.after.event_initialized.dapui = dapui.open
          dap.listeners.before.event_terminated.dapui = dapui.close
          dap.listeners.before.event_exited.dapui = dapui.close
        end,
      },
      {
        "leoluz/nvim-dap-go",
        opts = {},
        keys = {
          { "<leader>dT", function() require("dap-go").debug_test() end, ft = "go", desc = "Depurar test de Go" },
        },
      },
    },
    keys = {
      { "<leader>db", dap_call("toggle_breakpoint"), desc = "Punto de interrupción" },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Condición: "))
        end,
        desc = "Punto condicional",
      },
      { "<leader>dc", dap_call("continue"), desc = "Iniciar/continuar" },
      { "<leader>di", dap_call("step_into"), desc = "Entrar" },
      { "<leader>do", dap_call("step_over"), desc = "Saltar" },
      { "<leader>dO", dap_call("step_out"), desc = "Salir de la función" },
      { "<leader>dr", dap_call("run_last"), desc = "Repetir" },
      { "<leader>dt", dap_call("terminate"), desc = "Terminar" },
      { "<F5>", dap_call("continue"), desc = "Debug: continuar" },
      { "<F9>", dap_call("toggle_breakpoint"), desc = "Debug: punto de interrupción" },
      { "<F10>", dap_call("step_over"), desc = "Debug: saltar" },
      { "<F11>", dap_call("step_into"), desc = "Debug: entrar" },
    },
    config = function()
      local dap = require("dap")
      setup_javascript(dap)
      setup_php(dap)
      setup_lldb(dap)
      setup_kotlin(dap)

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "CursorLine" })

      require("dapui")
    end,
  },
}
