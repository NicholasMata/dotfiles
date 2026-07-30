local minimum_neovim_version = { 0, 11, 0 }

local function version_string(version)
  return string.format("%d.%d.%d", version.major, version.minor, version.patch)
end

local function check_neovim_version()
  local current = vim.version()
  local current_string = version_string(current)
  local minimum_string = version_string({
    major = minimum_neovim_version[1],
    minor = minimum_neovim_version[2],
    patch = minimum_neovim_version[3],
  })

  if vim.version.ge(current, minimum_neovim_version) then
    vim.health.ok("Neovim " .. current_string)
  else
    vim.health.error(
      string.format(
        "Neovim %s is unsupported; version %s or newer is required for the native LSP configuration",
        current_string,
        minimum_string
      )
    )
  end
end

local function check_executables(title, executables, report_missing)
  vim.health.start(title)

  for _, executable in ipairs(executables) do
    if vim.fn.executable(executable) == 1 then
      vim.health.ok(executable)
    else
      report_missing(executable .. " was not found in PATH")
    end
  end
end

return {
  check = function()
    vim.health.start("Dotfiles Neovim configuration")
    check_neovim_version()

    check_executables("Core command-line tools", {
      "git",
      "make",
      "unzip",
      "rg",
      "fd",
    }, vim.health.error)

    check_executables("Feature-specific command-line tools", {
      "codex-acp",
      "lazygit",
      "markdownlint-cli2",
      "stylua",
      "taplo",
      "tree-sitter",
    }, vim.health.warn)

    vim.health.info("Install managed command-line tools with `make dependencies`")
  end,
}
