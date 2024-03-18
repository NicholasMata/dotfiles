local pid = vim.fn.getpid()
-- This assumes you use LunarVim and have omnisharp installed 
local omnisharp_bin = os.getenv( "HOME" ) .. "/.local/share/lvim/mason/bin/omnisharp"

local config = {
    handlers = {
      ["textDocument/definition"] = require('omnisharp_extended').handler,
  },
  cmd = { omnisharp_bin, '--languageserver', '--hostPID', tostring(pid) }
}

require("lvim.lsp.manager").setup("omnisharp", config)
