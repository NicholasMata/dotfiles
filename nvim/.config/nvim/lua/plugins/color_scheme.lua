return {
  -- { -- You can easily change to a different colorscheme.
  --   'folke/tokyonight.nvim',
  --   priority = 1000,
  --   init = function()
  --     vim.cmd.colorscheme 'tokyonight-night'

  --     -- You can configure highlights by doing something like:
  --     vim.cmd.hi 'Comment gui=none'
  --   end,
  -- }
  -- Auto change vim theme on mode
  {
    'f-person/auto-dark-mode.nvim',
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.api.nvim_set_option('background', 'dark')
      end,
      set_light_mode = function()
        vim.api.nvim_set_option('background', 'light')
      end,
    }
  },

  -- Theme
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    config = true,
    init = function()
      vim.cmd.colorscheme('rose-pine')
    end
  }
}
