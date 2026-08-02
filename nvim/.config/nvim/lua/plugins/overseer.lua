local function restart_last_task()
  local overseer = require("overseer")
  local tasks = overseer.list_tasks({ recent_first = true })

  if vim.tbl_isempty(tasks) then
    vim.notify("No Overseer tasks found", vim.log.levels.WARN)
    return
  end

  overseer.run_action(tasks[1], "restart")
end

return {
  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerRun",
      "OverseerTaskAction",
      "OverseerToggle",
    },
    opts = {},
    keys = {
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "[r]un task" },
      { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "[t]oggle tasks" },
      { "<leader>ol", restart_last_task, desc = "restart [l]ast task" },
      { "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "task [a]ctions" },
    },
  },
}
