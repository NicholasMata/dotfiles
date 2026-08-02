local M = {}

local failures = {}

local function fail(message)
  table.insert(failures, message)
end

local function expect_key(table_value, key, description)
  if type(table_value) ~= "table" or table_value[key] == nil then
    fail(string.format("missing %s: %s", description, key))
  end
end

local function expect_keys(table_value, keys, description)
  for _, key in ipairs(keys) do
    expect_key(table_value, key, description)
  end
end

local function expect_list_values(list, values, description)
  for _, value in ipairs(values) do
    if not vim.tbl_contains(list or {}, value) then
      fail(string.format("missing %s: %s", description, value))
    end
  end
end

local function expect_unique(list, description)
  local seen = {}

  for _, value in ipairs(list or {}) do
    if seen[value] then
      fail(string.format("duplicate %s: %s", description, value))
    end
    seen[value] = true
  end
end

local function plugin_opts(name)
  local lazy_config = require("lazy.core.config")
  local plugin = lazy_config.plugins[name]

  if not plugin then
    fail("missing plugin specification: " .. name)
    return {}
  end

  return require("lazy.core.plugin").values(plugin, "opts", false) or {}
end

function M.run()
  failures = {}

  local lsp = plugin_opts("nvim-lspconfig")
  expect_keys(lsp.servers, {
    "bashls",
    "cssls",
    "kotlin_language_server",
    "lua_ls",
    "roslyn",
    "sourcekit",
    "taplo",
    "vtsls",
  }, "LSP server")
  expect_list_values(lsp.ensure_installed, {
    "biome",
    "jsonlint",
    "ktlint",
    "oxlint",
    "prettierd",
    "roslyn-language-server",
    "sql-formatter",
    "vale",
  }, "Mason tool")
  expect_unique(lsp.ensure_installed, "Mason tool")
  expect_unique(lsp.manually_enabled_servers, "manually enabled LSP server")
  expect_unique(lsp.automatic_enable_exclusions, "automatic LSP exclusion")

  local conform = plugin_opts("conform.nvim")
  expect_keys(conform.formatters_by_ft, {
    "css",
    "javascript",
    "javascriptreact",
    "json",
    "kotlin",
    "lua",
    "sql",
    "swift",
    "toml",
    "typescript",
    "typescriptreact",
    "xml",
  }, "formatter filetype")

  local lint = plugin_opts("nvim-lint")
  expect_keys(lint.linters_by_ft, { "json", "markdown", "text" }, "linter filetype")
  expect_keys(lint.project_linters, {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  }, "project-aware linter filetype")

  local treesitter = plugin_opts("nvim-treesitter")
  expect_list_values(treesitter.ensure_installed, {
    "bash",
    "c_sharp",
    "css",
    "html",
    "javascript",
    "json",
    "kotlin",
    "lua",
    "luadoc",
    "markdown",
    "sql",
    "swift",
    "toml",
    "tsx",
    "typescript",
  }, "Treesitter parser")
  expect_unique(treesitter.ensure_installed, "Treesitter parser")
  expect_unique(treesitter.highlight_filetypes, "Treesitter highlight filetype")
  expect_unique(treesitter.indent_filetypes, "Treesitter indent filetype")

  local dap = plugin_opts("nvim-dap")
  expect_list_values(dap.ensure_installed, { "coreclr", "delve", "js", "kotlin" }, "debug adapter")
  expect_unique(dap.ensure_installed, "debug adapter")

  if #failures > 0 then
    for _, message in ipairs(failures) do
      vim.api.nvim_err_writeln("Neovim configuration check: " .. message)
    end
    vim.cmd("cquit")
    return
  end

  vim.api.nvim_out_write("Neovim configuration structure is valid\n")
end

return M
