local constants = require("overseer.constants")

local commands = {
  { name = "dotnet build", args = { "build" }, tags = { constants.TAG.BUILD } },
  { name = "dotnet test", args = { "test" }, tags = { constants.TAG.TEST } },
  { name = "dotnet run", args = { "run" }, tags = { constants.TAG.RUN } },
}

local function find_project(opts)
  return vim.fs.find(function(name)
    return name:match("%.slnx?$") or name:match("%.csproj$")
  end, { upward = true, type = "file", path = opts.dir })[1]
end

return {
  cache_key = find_project,
  generator = function(opts)
    if vim.fn.executable("dotnet") == 0 then
      return 'Command "dotnet" not found'
    end

    local project = find_project(opts)
    if not project then
      return "No .sln, .slnx, or .csproj file found"
    end

    local cwd = vim.fs.dirname(project)
    local target = vim.fs.basename(project)
    local templates = {}

    for _, command in ipairs(commands) do
      if command.args[1] ~= "run" or target:match("%.csproj$") then
        table.insert(templates, {
          name = command.name,
          tags = command.tags,
          builder = function()
            local args = vim.list_extend({ "dotnet" }, vim.deepcopy(command.args))
            if command.args[1] == "run" then
              vim.list_extend(args, { "--project", target })
            else
              table.insert(args, target)
            end
            return { cmd = args, cwd = cwd }
          end,
        })
      end
    end

    return templates
  end,
}
