vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "csharp_ls" })

local pid = vim.fn.getpid()
local omnisharp_bin = "/Users/nicholasmata/.local/share/lvim/mason/bin/omnisharp"

local config = {
  handlers = {
    ["textDocument/definition"] = require('omnisharp_extended').handler,
  },
  cmd = { omnisharp_bin, '--languageserver' , '--hostPID', tostring(pid) },
}

require("lvim.lsp.manager").setup("omnisharp", config)

