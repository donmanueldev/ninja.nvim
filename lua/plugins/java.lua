-- Java con nvim-jdtls: incluye debug y tests, que lspconfig solo no ofrece.
local mason = vim.fn.stdpath("data") .. "/mason"

local function java_home(version)
  local out = vim.system({ "/usr/libexec/java_home", "-v", version }, { text = true }):wait()
  return out.code == 0 and vim.trim(out.stdout) or nil
end

-- jdtls exige Java 25 o superior, aunque tu proyecto compile con otra versión.
local function jdtls_java_home()
  local brew = "/opt/homebrew/opt/openjdk@25/libexec/openjdk.jdk/Contents/Home"
  if vim.fn.executable(brew .. "/bin/java") == 1 then
    return brew
  end
  local home = java_home("25+")
  return home and home:find("25", 1, true) and home or nil
end

local function bundles()
  local jars = vim.fn.glob(
    mason .. "/share/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar",
    true,
    true
  )
  vim.list_extend(jars, vim.fn.glob(mason .. "/share/java-test/*.jar", true, true))
  return vim.tbl_filter(function(jar)
    return not jar:match("com%.microsoft%.java%.test%.runner%-jar%-with%-dependencies")
      and not jar:match("jacocoagent")
  end, jars)
end

local function runtimes()
  local list = {}
  for name, version in pairs({ ["JavaSE-17"] = "17", ["JavaSE-21"] = "21", ["JavaSE-24"] = "24" }) do
    local path = java_home(version)
    if path and path:find(version, 1, true) then
      table.insert(list, { name = name, path = path })
    end
  end
  table.insert(list, { name = "JavaSE-25", path = jdtls_java_home() })
  return list
end

local function start()
  local root = vim.fs.root(0, { "gradlew", "mvnw", "pom.xml", "build.gradle", "build.gradle.kts", ".git" })
  if not root then
    return
  end
  local runtime = jdtls_java_home()
  if not runtime then
    vim.notify("Java: jdtls necesita JDK 25. Instálalo con: brew install openjdk@25", vim.log.levels.ERROR)
    return
  end
  local jdtls = require("jdtls")
  local workspace = vim.fn.stdpath("cache") .. "/jdtls/" .. vim.fn.sha256(root):sub(1, 16)

  jdtls.start_or_attach({
    cmd = {
      mason .. "/bin/jdtls",
      "--jvm-arg=-javaagent:" .. mason .. "/share/jdtls/lombok.jar",
      "-data",
      workspace,
    },
    cmd_env = { JAVA_HOME = runtime },
    root_dir = root,
    capabilities = require("blink.cmp").get_lsp_capabilities(),
    init_options = { bundles = bundles() },
    settings = {
      java = { configuration = { runtimes = runtimes() } },
    },
    on_attach = function()
      jdtls.setup_dap({ hotcodereplace = "auto" })
      require("jdtls.dap").setup_dap_main_class_configs()
    end,
  })
end

return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  dependencies = { "mfussenegger/nvim-dap", "neovim/nvim-lspconfig" },
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("user_java", { clear = true }),
      pattern = "java",
      callback = start,
    })
    start()
  end,
}
