return {
  -- lazy
  {
    "sontungexpt/witch-line",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false, -- Almost component is lazy load by default. So you can set lazy to false
    opts = {},
    config = function(config, opts)
      require("witch-line").setup(opts)
      vim.opt.laststatus = 3
    end,
  },
}
