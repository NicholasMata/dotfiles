local constants = require("overseer.constants")

local commands = {
  { task = "build", tags = { constants.TAG.BUILD } },
  { task = "test", tags = { constants.TAG.TEST } },
  { task = "run", tags = { constants.TAG.RUN } },
}

local function find_project(opts)
  return vim.fs.find({ "gradlew", "build.gradle.kts", "build.gradle" }, {
    upward = true,
    type = "file",
    path = opts.dir,
  })[1]
end

return {
  cache_key = find_project,
  generator = function(opts)
    local project = find_project(opts)
    if not project then
      return "No Gradle project found"
    end

    local cwd = vim.fs.dirname(project)
    local wrapper = vim.fs.joinpath(cwd, "gradlew")
    local executable = vim.uv.fs_stat(wrapper) and "./gradlew" or "gradle"
    if executable == "gradle" and vim.fn.executable(executable) == 0 then
      return 'Command "gradle" not found and no Gradle wrapper is available'
    end

    local templates = {}
    for _, command in ipairs(commands) do
      table.insert(templates, {
        name = string.format("%s %s", executable, command.task),
        tags = command.tags,
        builder = function()
          return {
            cmd = { executable, command.task },
            cwd = cwd,
          }
        end,
      })
    end
    return templates
  end,
}
