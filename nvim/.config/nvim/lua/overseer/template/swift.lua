local constants = require("overseer.constants")

local commands = {
  { command = "build", tags = { constants.TAG.BUILD } },
  { command = "test", tags = { constants.TAG.TEST } },
  { command = "run", tags = { constants.TAG.RUN } },
}

local function find_package(opts)
  return vim.fs.find("Package.swift", { upward = true, type = "file", path = opts.dir })[1]
end

return {
  cache_key = find_package,
  generator = function(opts)
    if vim.fn.executable("swift") == 0 then
      return 'Command "swift" not found'
    end

    local package = find_package(opts)
    if not package then
      return "No Package.swift file found"
    end

    local cwd = vim.fs.dirname(package)
    local templates = {}
    for _, command in ipairs(commands) do
      table.insert(templates, {
        name = "swift " .. command.command,
        tags = command.tags,
        builder = function()
          return {
            cmd = { "swift", command.command },
            cwd = cwd,
          }
        end,
      })
    end
    return templates
  end,
}
