return {
  {                     -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      local which_key = require('which-key')
      which_key.setup()

      -- Document existing key chains
      which_key.register({
        c = { name = '[C]ode', _ = 'which_key_ignore' },
        d = { name = '[D]ocument', _ = 'which_key_ignore' },
        r = { name = '[R]ename', _ = 'which_key_ignore' },
        s = { name = '[S]earch', _ = 'which_key_ignore' },
        w = { name = '[W]orkspace', _ = 'which_key_ignore' },
        t = { name = '[T]oggle', _ = 'which_key_ignore' },
        h = { name = 'Git [H]unk', _ = 'which_key_ignore' },
        v = { ":call system('say '.shellescape(expand('<cword>')).' &')<CR>", "Speak Word" }
      }, { mode = 'n', prefix = '<leader>' })
      -- visual mode
      --
      -- lvim.builtin.which_key.mappings["v"] = { 'Speak Word' }
      -- lvim.builtin.which_key.vmappings["v"] = { 'Speak Selection' }
      -- lvim.keys.visual_mode["<leader>v"] = { '"xy:call system(\'say \'. shellescape(@x) .\' &\')<CR>', desc = 'Speak' }
      -- lvim.keys.normal_mode["<leader>v"] = ":call system('say '.shellescape(expand('<cword>')).' &')<CR>"
      which_key.register({
        h = { 'Git [H]unk' },
        v = { '"xy:call system(\'say \'. shellescape(@x) .\' &\')<CR>', 'Speak Selection' }
      }, { mode = 'v', prefix = '<leader>' })
    end,
  },
}
