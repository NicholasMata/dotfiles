return {
  "paulbkim-dev/vim-herdr-navigation",
  lazy = false,
  dependencies = {
    "christoomey/vim-tmux-navigator",
  },
  config = function(plugin)
    dofile(plugin.dir .. "/editor/nvim.lua")
  end,
}
