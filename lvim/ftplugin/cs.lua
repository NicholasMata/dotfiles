local util = require 'lspconfig.util'
local config = {
  handlers = {
    ["textDocument/definition"] = require('csharpls_extended').handler,
  },
  cmd = { 'csharp-ls' },
  root_dir = util.root_pattern('../*.sln', '../*.csproj', '*.sln', '*.csproj', '*.fsproj', '.git'),
  filetypes = { 'cs' },
  init_options = {
    AutomaticWorkspaceInit = true,
  },
}

require('lvim.lsp.manager').setup("csharp_ls", config)
