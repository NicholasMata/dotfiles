return {
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
  {
    -- Autoformat
    "stevearc/conform.nvim",
    lazy = false,
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        -- Disable LSP formatting for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and "never" or "fallback",
        }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        typescriptreact = { "biome", "prettierd", stop_after_first = true },
        typescript = { "biome", "prettierd", stop_after_first = true },
        javascriptreact = { "biome", "prettierd", stop_after_first = true },
        javascript = { "biome", "prettierd", stop_after_first = true },
        json = { "biome" },
        xml = { "xmllint" },
      },
      formatters = {
        xmllint = {
          command = "xmllint",
          args = { "--format", "-" },
          stdin = true,
        },
        biome = {
          require_cwd = true,
        },
        prettierd = {
          require_cwd = true,
        },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)

      local safe_write_state

      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })

      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = "Re-enable autoformat-on-save",
      })

      vim.api.nvim_create_user_command("SafeWriteMode", function()
        if safe_write_state then
          vim.notify("Safe-write mode is already enabled")
          return
        end

        safe_write_state = {
          disable_autoformat = vim.g.disable_autoformat,
          editorconfig = vim.g.editorconfig,
        }

        vim.g.disable_autoformat = true
        vim.g.editorconfig = false

        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(bufnr) then
            vim.b[bufnr].editorconfig = false
          end
        end

        -- EditorConfig may already have registered write-time whitespace
        -- transformations for loaded buffers.
        pcall(vim.api.nvim_clear_autocmds, {
          event = "BufWritePre",
          group = "nvim.editorconfig",
        })

        vim.notify("Safe-write mode enabled for this Neovim session")
      end, {
        desc = "Disable automatic write-time transformations",
      })

      vim.api.nvim_create_user_command("SafeWriteModeDisable", function()
        if not safe_write_state then
          vim.notify("Safe-write mode is not enabled")
          return
        end

        vim.g.disable_autoformat = safe_write_state.disable_autoformat
        vim.g.editorconfig = safe_write_state.editorconfig
        safe_write_state = nil

        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(bufnr) then
            vim.b[bufnr].editorconfig = nil
            local filename = vim.api.nvim_buf_get_name(bufnr)
            if vim.g.editorconfig ~= false and filename ~= "" then
              require("editorconfig").config(bufnr)
            end
          end
        end

        vim.notify("Safe-write mode disabled")
      end, {
        desc = "Restore automatic write-time transformations",
      })

      vim.api.nvim_set_keymap(
        "n",
        "<leader>fd",
        ":FormatDisable<CR>",
        { noremap = true, silent = true, desc = "[f]ormat [d]isable" }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<leader>fe",
        ":FormatEnable<CR>",
        { noremap = true, silent = true, desc = "[f]ormat [e]nable" }
      )
      -- vim.keymap.set("n", "<leader>fb", function()
      -- 	require("conform").format({ async = true, lsp_format = "fallback" })
      -- end, { noremap = true, silent = true, desc = "[f]ormat [b]uffer" })
    end,
  },
}
