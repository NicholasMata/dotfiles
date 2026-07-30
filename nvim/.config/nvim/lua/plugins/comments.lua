return {
  -- Highlight todo, notes, etc in comments
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  -- "gc" to comment visual regions/lines
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    opts = function()
      return {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "BufReadPost",
    opts = {
      enable_autocmd = false,
    },
  },
  -- documentation comments
  {
    "kkoomen/vim-doge",
    lazy = false,
    keys = {
      { "gcd", "<cmd>DogeGenerate<cr>", desc = "generate documentation comment" },
    },
    build = ":call doge#install()",
    init = function()
      vim.g.doge_enable_mappings = 0
      vim.g.doge_javascript_settings = {
        destructuring_props = 1,
        omit_redundant_param_types = 1,
      }
    end,
  },
}
