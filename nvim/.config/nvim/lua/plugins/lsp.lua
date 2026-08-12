return {
  { -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        "j-hui/fidget.nvim",
        opts = {
          notification = {
            window = {
              winblend = 0,
            },
          },
        },
      },

      { "Issafalcon/lsp-overloads.nvim", opts = { focusable = true } },
    },
    opts = {
      servers = {},
      externally_managed_servers = {},
      ensure_installed = { "vale" },
      manually_enabled_servers = {},
      automatic_enable_exclusions = {
        "biome",
      },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("mata-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          -- map("gd", vim.lsp.buf.definition, "[g]oto [d]efinition")

          -- -- Find references for the word under your cursor.
          -- map("fr", require("telescope.builtin").lsp_references, "[f]ind [r]eferences")
          --
          -- -- Jump to the implementation of the word under your cursor.
          -- --  Useful when your language has ways of declaring types without an actual implementation.
          -- map("gi", require("telescope.builtin").lsp_implementations, "[g]oto [i]mplementation")
          --
          -- -- Jump to the type of the word under your cursor.
          -- --  Useful when you're not sure what type a variable is and you want to see
          -- --  the definition of its *type*, not where it was *defined*.
          -- map("gtd", require("telescope.builtin").lsp_type_definitions, "[g]oto [t]ype [d]efinition")
          --
          -- -- Fuzzy find all the symbols in your current document.
          -- --  Symbols are things like variables, functions, types, etc.
          -- map("<leader>ld", require("telescope.builtin").lsp_document_symbols, "[d]ocument symbols")
          --
          -- -- Fuzzy find all the symbols in your current workspace.
          -- --  Similar to document symbols, except searches over your entire project.
          -- map("<leader>lw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[w]orkspace symbols")
          --

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map("<leader>lr", vim.lsp.buf.rename, "[r]ename symbol")

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map("<leader>lc", vim.lsp.buf.code_action, "[c]ode action")

          map("<leader>ls", function()
            vim.lsp.buf.code_action({ context = { only = { "source" } } })
          end, "[s]ource action")

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map("K", vim.lsp.buf.hover, "[K]eyword documentation")

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          -- map("gD", vim.lsp.buf.declaration, "[g]oto [D]eclaration")

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup("mata-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("mata-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "mata-lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          -- if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          -- 	map("<leader>li", function()
          -- 		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          -- 	end, "[i]nlay hints toggle")
          -- end

          --- Guard against servers without the signatureHelper capability
          if client and client.server_capabilities.signatureHelpProvider then
            require("lsp-overloads").setup(client, { display_automatically = false })
            map("go", "<cmd>LspOverloadsSignature<CR>", "[o]verload Documentation")
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require("mason").setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_filter(function(name)
        return not opts.externally_managed_servers[name]
      end, vim.tbl_keys(opts.servers or {}))
      vim.list_extend(ensure_installed, opts.ensure_installed)
      -- Global rounded-border tweak for LSP floating windows
      local orig_open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, preview_opts, ...)
        preview_opts = preview_opts or {}
        preview_opts.border = preview_opts.border or "rounded"
        return orig_open_floating_preview(contents, syntax, preview_opts, ...)
      end

      -- Apply our per-server config using the new vim.lsp.config API
      for server_name, server in pairs(opts.servers) do
        -- merge cmp capabilities into each server
        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

        -- This **replaces** require('lspconfig')[server].setup{...}
        vim.lsp.config(server_name, server)
      end

      for _, server_name in ipairs(opts.manually_enabled_servers) do
        vim.lsp.enable(server_name)
      end

      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      -- mason-lspconfig v2: auto-enable installed servers after our configs are registered.
      -- We keep installs driven by mason-tool-installer above.
      require("mason-lspconfig").setup({
        -- we don't ask it to install anything, just to enable what exists
        automatic_enable = {
          exclude = opts.automatic_enable_exclusions,
        },
      })
    end,
  },
}
